import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

class ContractLinking extends ChangeNotifier {
  final String rpcUrl = "http://127.0.0.1:7545";
  final String wsUrl = "ws://127.0.0.1:7545";
  final String privateKey =
      "0e0badf0b75bf2d08ba5c9c57d28e66b2055f5cd8f9e96751f8848172147fb90";
  
  //hello

  Web3Client? _client;
  bool isLoading = true;

  String? abiCode;
  EthereumAddress? contractAddress;

  Credentials? credentials;

  DeployedContract? contract;
  ContractFunction? _message;
  ContractFunction? _setMessage;

  String? deployedName;

  ContractLinking() {
    setup();
  }

  setup() async {
    _client = Web3Client(rpcUrl, Client());
    await getAbi();
    await getCredentials();
    await getDeployedContract();
  }

  Future<void> getAbi() async {
    String abiStringfile =
        await rootBundle.loadString("src/abis/HelloWorld.json");
    final jsonAbi = jsonDecode(abiStringfile);
    abiCode = jsonEncode(jsonAbi['abi']);
    contractAddress =
        EthereumAddress.fromHex(jsonAbi['networks']['5777']['address']);
    print(contractAddress);
  }

  Future<void> getCredentials() async {
    credentials = EthPrivateKey.fromHex(privateKey);
  }

  Future<void> getDeployedContract() async {
    contract = DeployedContract(
        ContractAbi.fromJson(abiCode!, "HelloWorld"), contractAddress!);
    _message = contract!.function('message');
    _setMessage = contract!.function('setMessage');
    getMessage();
  }

  void setMessage(String message) async {
    isLoading = true;
    notifyListeners();
    await _client!.sendTransaction(
        credentials!,
        Transaction.callContract(
            contract: contract!,
            function: _setMessage!,
            parameters: [message]));
    getMessage();
  }

  getMessage() async {
    // ignore: no_leading_underscores_for_local_identifiers
    List _mymessage = await _client!
        .call(contract: contract!, function: _message!, params: []);
    deployedName = _mymessage[0];
    isLoading = false;
    notifyListeners();
  }
}
