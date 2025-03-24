#!/bin/bash

# Anahtar dosyalarını temizle
rm -f private_key.pem public_key.pem message.enc message.txt decrypted.txt

echo "🔐 RSA 2048-bit anahtar çifti oluşturuluyor..."
openssl genpkey -algorithm RSA -out private_key.pem -pkeyopt rsa_keygen_bits:2048

echo "📤 Public key çıkartılıyor..."
openssl rsa -pubout -in private_key.pem -out public_key.pem

echo "📄 Mesaj dosyası oluşturuluyor..."
echo "Hello students! This is a secret message." > message.txt

echo "🔒 Mesaj public key ile şifreleniyor..."
openssl pkeyutl -encrypt -pubin -inkey public_key.pem -in message.txt -out message.enc

echo "🔓 Şifreli mesaj private key ile çözülüyor..."
openssl pkeyutl -decrypt -inkey private_key.pem -in message.enc -out decrypted.txt

echo "✅ Orijinal mesaj:"
cat message.txt

echo -e "\n✅ Çözülmüş mesaj:"
cat decrypted.txt

echo -e "\n🎉 İşlem tamamlandı. Dosyalar: private_key.pem, public_key.pem, message.enc, decrypted.txt"
