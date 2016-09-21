package com.amarsoft.app.als.sys.tools;

import java.security.MessageDigest;

public class SHA1Tools {
	public static String encryptMessage(String message) throws Exception{
		MessageDigest md = MessageDigest.getInstance("SHA-1");
		md.update(message.getBytes());
		byte[] data = md.digest();
		
		//System.out.println(byte2hex(data));
		return byte2hex(data);
	}
	
	
	public static String byte2hex(byte [] b){
		String tmp = "",rtn = "";
		for(int i = 0;i<b.length;i++){
			tmp = Integer.toHexString(b[i]&0XFF);
			if(tmp.length()==1){
				rtn = rtn+"0"+tmp;
			}else{
				rtn = rtn+tmp;
			}
		}
		return rtn.toUpperCase();
	}
}
