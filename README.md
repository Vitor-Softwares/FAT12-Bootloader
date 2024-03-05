# FAT12-Bootloader
Bootloader de duas etapas, montado em fat12, o mesmo faz a função de boot e imprime uma imagem codificada usando o CompressorBMP monocromático, mas pode ser alterado para que seja usada em outras funções. O código foi escrito de forma rápida então com certeza tem redundâncias.

Na variavel de dados é necessario adicionar <,255> no ultimo dados a ser lido.
![image](https://github.com/Vitor-Softwares/FAT12-Bootloader/assets/77505348/b63ee940-5c48-42c4-bc6f-4915e04197a0)



CompressorBMP: https://github.com/Vitor-Softwares/CompressorBMP
