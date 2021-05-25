// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

import "./Token.sol";

contract Presale is Ownable {
    using SafeMath for uint256;
    using Address for address;
    string public name = "DISG Presale";
    Disastergirltoken public token;
    uint256 public rate = 200 * 10**6;
    bool public isActive = false;
    uint256 private _TAX_FEE = 600;
    uint256 private _BURN_FEE = 600;
    uint256 private _DECIMALFACTOR = 10**9;

    modifier presaleActive() {
        require(isActive, "Presale not active");
        _;
    }

    event TokenPurchased(
        address account,
        address token,
        uint256 amount,
        uint256 rate
    );

    constructor(Disastergirltoken _token) {
        token = _token;
    }

    function buyTokens() public payable presaleActive() {
        require(msg.value >= 1 * 10**16, "Minimum purchase amount 0.01 BNB");
        // Calculate the number of tokens to buy
        uint256 maxFeeBurn = 10000;
        require(_BURN_FEE.add(_TAX_FEE) <= maxFeeBurn, "Burn Fee + Tax Fee >= maxFeeBurn");
        uint256 tokenAmount = msg.value.mul(rate).div(_DECIMALFACTOR).mul(maxFeeBurn).div(maxFeeBurn.sub(_TAX_FEE).sub(_BURN_FEE));

        // Require that Presale has enough tokens
        require(
            token.balanceOf(address(this)) >= tokenAmount,
            "Not enought balance on Presale Contract"
        );

        // Transfer tokens to the user
        token.transfer(msg.sender, tokenAmount);

        // Emit an event
        emit TokenPurchased(msg.sender, address(token), tokenAmount, rate);
    }

    function togglePresale() public onlyOwner() {
        isActive = !isActive;
    }

    function withdrawBNB() public onlyOwner() {
        payable(msg.sender).transfer(address(this).balance);
    }

    function withdrawDISG() public onlyOwner() {
        token.transfer(msg.sender, token.balanceOf(address(this)));
    }

    function setRate(uint256 _rate) public onlyOwner() {
        rate = _rate;
    }

    function TAXFEE(uint256 taxFee) external onlyOwner() {
        _TAX_FEE = taxFee;
    }

    function BURNFEE(uint256 burnFee) external onlyOwner() {
        _BURN_FEE = burnFee;
    }
}
