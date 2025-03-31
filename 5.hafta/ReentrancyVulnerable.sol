// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Savunmasız kontrat: Reentrancy açığı içerir
contract ReentrancyVulnerable {
    // Kullanıcıların bakiyelerini tutan mapping
    mapping(address => uint256) public balances;

    // Kullanıcının kontrata Ether yatırmasını sağlar
    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    // Kullanıcının bakiyesinden Ether çekmesini sağlar (Reentrancy açığı burada)
    function withdraw(uint256 _amount) public {
        // Kullanıcının yeterli bakiyesi var mı kontrol et
        require(balances[msg.sender] >= _amount, "Yetersiz bakiye");

        // Ether'i kullanıcıya gönder (Dış çağrı - Reentrancy riski burada)
        (bool success, ) = msg.sender.call{value: _amount}("");
        require(success, "Transfer basarisiz");

        // Bakiyeyi güncelle (Hatalı sıralama: Önce dış çağrı yapıldı, sonra bakiye güncellendi)
        balances[msg.sender] -= _amount;
    }

    // Kontratın toplam bakiyesini kontrol etmek için yardımcı fonksiyon
    function getContractBalance() public view returns (uint256) {
        return address(this).balance;
    }
}
