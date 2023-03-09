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
      "89fdbb0078ad1c490af25c3bee0e9cc1129988e49b1f485c6e350db92cc3b163";

  Web3Client? web3client;
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
    web3client = Web3Client(rpcUrl, Client(), socketConnector: () {
      return IOWebSocketChannel.connect(wsUrl).cast<String>();
    });

    Future<void> getAbi() async {
      String abiStringfile =
          await rootBundle.loadString("build/contracts/HelloWorld.json");
      final jsonAbi = jsonDecode(abiStringfile);
      abiCode = jsonEncode(jsonAbi['abi']);
      contractAddress =
          EthereumAddress.fromHex(jsonAbi['networks']['5777']['address']);
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

    await getAbi();
    await getCredentials();
    await getDeployedContract();
  }

  void setMessage(String message) async {
    isLoading = true;
    notifyListeners();
    await web3client!.sendTransaction(
        credentials!,
        Transaction.callContract(
            contract: contract!,
            function: _setMessage!,
            parameters: [message]));
    getMessage();
  }

  getMessage() async {
    final _mymessage = await web3client!
        .call(contract: contract!, function: _message!, params: []);
    deployedName = _mymessage[0];
    isLoading = false;
    notifyListeners();
  }
}
