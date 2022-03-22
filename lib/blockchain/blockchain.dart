import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:web3dart/web3dart.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class BlockchainUtils {
  http.Client httpClient;
  Web3Client ethClient;
  final contractAddress = dotenv.env["FIRST_COIN_CONTRACT_ADDRESS"];
  EthereumAddress wallet_address = EthereumAddress.fromHex(dotenv.env["METAMASK_RINKEBY_WALLET_ADDRESS"]);

  void initialSetup() {
    httpClient = http.Client();
    String infura = "https://rinkeby.infura.io/v3/" + dotenv.env['INFURA_PROJECT_ID'];
    ethClient = Web3Client(infura, httpClient);
  }

  Future<DeployedContract> getDeployedContract() async {
    String abi = await rootBundle.loadString("assets/abi/abi_token.json");
    final contract = DeployedContract(ContractAbi.fromJson(abi, "HelpVetTokenUpgradeableV3"), EthereumAddress.fromHex(contractAddress));
    return contract;
  }

  Future<String> createAccount(String nameAccount, String password, String email, String privateKey) async {
    var response = await submit("createAccount", [nameAccount, password, email], privateKey);
    return response;
  }

  Future<String> loginAccount(String email, String password) async {
    List<dynamic> dataLogin = await query("loginAccount3", [email, password]);
    var myData = dataLogin[0];
    return myData;
  }

  Future<String> getName() async {
    List<dynamic> result = await query("name", []);
    var myData = result[0];
    return myData;
  }

  Future<String> getSymbol() async {
    List<dynamic> result = await query("symbol", []);
    var myData = result[0];
    return myData;
  }

  Future getBalanceOf(EthereumAddress address) async {
    List<dynamic> result = await query("balanceOf", [address]);
    var myData = result[0];
    return myData;
  }

  Future<String> transfer(EthereumAddress address, double amount, String privateKey) async {
    address = wallet_address;
    var bigAmount = BigInt.from(amount);
    var response = await submit("transfer", [address, bigAmount], privateKey);
    return response;
  }

  Future<String> transferFrom(EthereumAddress fromAddress,EthereumAddress toAddress, double amount, String privateKey) async {
    var bigAmount = BigInt.from(amount);
    var response = await submit("transferFrom", [fromAddress,toAddress,bigAmount], privateKey);
    return response;
  }

  Future<String> withdrawCoin(double amount, String privateKey) async {
    var bigAmount = BigInt.from(amount);
    var response = await submit("withdrawBalance", [bigAmount], privateKey);
    return response;
  }

  Future<String> depositCoin(double amount, String privateKey) async {
    var bigAmount = BigInt.from(amount);
    var response = await submit("depositBalance", [bigAmount], privateKey);
    return response;
  }

  Future<List<dynamic>> query(String functionName, List<dynamic> args) async {
    final contract = await getDeployedContract();
    final ethFunction = contract.function(functionName);
    final result = await ethClient.call(
        contract: contract, function: ethFunction, params: args);
    return result;
  }

  Future<String> submit(String functionName, List<dynamic> args, String privateKey) async {
    try {
      EthPrivateKey credential = EthPrivateKey.fromHex(privateKey);
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
      print("Algo deu errado!");
    }
  }
}
