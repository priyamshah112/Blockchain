
var MyToken = artifacts.require("./MyToken.sol");

module.exports = function(deployer) {
  const _name="StockCoin";
  const _symbol="STC";
  const _decimals=0;

  deployer.deploy(MyToken,_name,_symbol,_decimals);
};

