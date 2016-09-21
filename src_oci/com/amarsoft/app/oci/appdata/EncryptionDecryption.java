package com.amarsoft.app.oci.appdata;

import java.security.Key;
import java.security.Security;


import javax.crypto.Cipher;

public class EncryptionDecryption {

	/**
	 * Լ����Կ
	 */
    private static String strDefaultKey = "amarsoft";
    private Cipher encryptCipher = null;
    private Cipher decryptCipher = null;
    
    public EncryptionDecryption() throws Exception {
        this(strDefaultKey);
    }

    public EncryptionDecryption(String strKey) throws Exception {
        Security.addProvider(new com.sun.crypto.provider.SunJCE());
        Key key = getKey(strKey.getBytes());

        encryptCipher = Cipher.getInstance("DES");
        encryptCipher.init(Cipher.ENCRYPT_MODE, key);

        decryptCipher = Cipher.getInstance("DES");
        decryptCipher.init(Cipher.DECRYPT_MODE, key);
    }
    
    /**
     * �ַ�������
     * @author zwcui
     * @param strIn
     * @return
     * @throws Exception
     */
    public String encrypt(String strIn) throws Exception {
        return byteArrToHexStr(encrypt(strIn.getBytes()));
    }

    /**
     * �ַ�������
     * @author zwcui
     * @param strIn
     * @return
     * @throws Exception
     */
    public String decrypt(String strIn) throws Exception {
        try {
            return new String(decrypt(hexStrToByteArr(strIn)));
        } catch (Exception e) {
            return "";
        }
    }
    
    /**
     * 
     * @param arrB
     * @return �ֽ�����ת��Ϊ16�����ַ���
     * @throws Exception
     */
    public static String byteArrToHexStr(byte[] arrB) throws Exception {
        int iLen = arrB.length;
        // ÿ��byte�������ַ����ܱ�ʾ�������ַ����ĳ��������鳤�ȵ�����
        StringBuffer sb = new StringBuffer(iLen * 2);
        for (int i = 0; i < iLen; i++) {
            int intTmp = arrB[i];
            // �Ѹ���ת��Ϊ����
            while (intTmp < 0) {
                intTmp = intTmp + 256;
            }
            // С��0F������Ҫ��ǰ�油0
            if (intTmp < 16) {
                sb.append("0");
            }
            sb.append(Integer.toString(intTmp, 16));
        }
        return sb.toString();
    }

    /**
     * 
     * @param strIn
     * @return 16�����ַ���ת��Ϊ�ֽ�����
     * @throws Exception
     */
    public static byte[] hexStrToByteArr(String strIn) throws Exception {
        byte[] arrB = strIn.getBytes();
        int iLen = arrB.length;

        // �����ַ���ʾһ���ֽڣ������ֽ����鳤�����ַ������ȳ���2
        byte[] arrOut = new byte[iLen / 2];
        for (int i = 0; i < iLen; i = i + 2) {
            String strTmp = new String(arrB, i, 2);
            arrOut[i / 2] = (byte) Integer.parseInt(strTmp, 16);
        }
        return arrOut;
    }

    public byte[] encrypt(byte[] arrB) throws Exception {
        return encryptCipher.doFinal(arrB);
    }


    public byte[] decrypt(byte[] arrB) throws Exception {
        return decryptCipher.doFinal(arrB);
    }

    private Key getKey(byte[] arrBTmp) throws Exception {
        // ����һ���յ�8λ�ֽ����飨Ĭ��ֵΪ0��
        byte[] arrB = new byte[8];
        // ��ԭʼ�ֽ�����ת��Ϊ8λ
        for (int i = 0; i < arrBTmp.length && i < arrB.length; i++) {
            arrB[i] = arrBTmp[i];
        }
        // ������Կ
        Key key = new javax.crypto.spec.SecretKeySpec(arrB, "DES");
        return key;
    }
    
    
}


