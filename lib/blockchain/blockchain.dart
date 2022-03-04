import 'dart:collection';

import 'package:flutter/services.dart';
import 'package:hex/hex.dart';
import 'package:http/http.dart' as http;
import 'package:web3dart/web3dart.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:math';

class BlockchainUtils {
  http.Client httpClient;
  Web3Client ethClient;
  final contractAddress = dotenv.env["FIRST_COIN_CONTRACT_ADDRESS"];
  EthereumAddress wallet_address =
      EthereumAddress.fromHex(dotenv.env["FIRST_COIN_CONTRACT_ADDRESS"]);

  void initialSetup() {
    httpClient = http.Client();
    String infura =
        "https://rinkeby.infura.io/v3/" + dotenv.env['INFURA_PROJECT_ID'];
    ethClient = Web3Client(infura, httpClient);
  }

  Future<DeployedContract> getDeployedContract() async {
    String abi = await rootBundle.loadString("assets/abi/abi_token.json");
    final contract = DeployedContract(ContractAbi.fromJson(abi, "HelpVetToken"),
        EthereumAddress.fromHex(contractAddress));

    return contract;
  }

  Future<String> createAccount(
      String nameAccount, String password, String email) async {
    var response =
        await submit("createAccount", [nameAccount, password, email]);
    return response;
  }

  Future<String> loginAccount(String email, String password) async {
    List<dynamic> dataLogin = await query("loginAccount", [email, password]);
    var myData = dataLogin[0];
    return myData;
  }

  Future getBalance() async {
    List<dynamic> result = await query("balances", [wallet_address]);
    var myData = result[0];
    return myData;
  }

  Future<String> transfer(EthereumAddress address, double amount) async {
    address = wallet_address;
    var bigAmount = BigInt.from(amount);
    var response = await submit("transfer", [address, bigAmount]);
    return response;
  }

  Future<String> withdrawCoin(double amount) async {
    var bigAmount = BigInt.from(amount);
    var response = await submit("withdrawBalance", [bigAmount]);
    return response;
  }

  Future<String> depositCoin(double amount) async {
    var bigAmount = BigInt.from(amount);
    var response = await submit("depositBalance", [bigAmount]);
    return response;
  }

  Future<HashMap> createWallet(String privateKey) async {
    var rng = Random.secure();
    //Credentials creds = EthPrivateKey.createRandom(rng);
    Credentials creds = EthPrivateKey.fromHex(privateKey);
    Wallet wallet = Wallet.createNew(creds, "minhasenha", rng);
    var address = await creds.extractAddress();
    var add = EthereumAddress.fromHex(address.toString());
    String ppk = HEX.encode(wallet.privateKey.privateKey);
    print(wallet.toJson());
    //HashMap obj = HashMap();
    //obj['privKey'] = ppk;
    //obj['pubKey'] = add;
    return null;
  }

  static Credentials getCredentials(privKey) {
    Credentials credentials = EthPrivateKey.fromHex(privKey);
    return credentials;
  }

  static Future<EthereumAddress> getPublicKey(pvteKey) async {
    EthereumAddress pubKey = await BlockchainUtils.getCredentials(pvteKey).extractAddress();

    return pubKey;
  }

  Future<List<dynamic>> query(String functionName, List<dynamic> args) async {
    final contract = await getDeployedContract();
    final ethFunction = contract.function(functionName);
    final result = await ethClient.call(
        contract: contract, function: ethFunction, params: args);
    return result;
  }

  Future<String> submit(String functionName, List<dynamic> args) async {
    try {
      EthPrivateKey credential =
          EthPrivateKey.fromHex(dotenv.env['METAMASK_PRIVATE_KEY']);
      DeployedContract contract = await getDeployedContract();
      final ethFunction = contract.function(functionName);
      final result = await ethClient.sendTransaction(
          credential,
          Transaction.callContract(
              contract: contract,
              function: ethFunction,
              parameters: args,
              maxGas: 100000),
          chainId: 4);
      return result;
    } catch (e) {
      print("Something wrong happened!");
    }
  }
}
