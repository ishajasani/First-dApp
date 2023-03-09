import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_dapp/contractLinking.dart';

class HelloPage extends StatelessWidget {
  const HelloPage({super.key});

  @override
  Widget build(BuildContext context) {
    final contractLink = Provider.of<ContractLinking>(context);
    final _messageController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter Dapp"),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: contractLink.isLoading? const CircularProgressIndicator():
          SingleChildScrollView(
            child: Form(child: Column
            (children: [
              Text("My first dApp ${contractLink.deployedName}" , style: const TextStyle(
                color: Colors.blue,
                fontSize: 20,
              ),),
              TextFormField(
                controller: _messageController,
                decoration: const InputDecoration(
                  hintText: 'Enter a message to send to the contract'
                ),
              ),
              const SizedBox(height: 20,),
              ElevatedButton(onPressed: () {
                contractLink.setMessage(_messageController.text);
                _messageController.clear();
              }, child: const Text("Set Message"))
            ],),
          )
        ),
      ),
    ),
    );
  }
}