package com.amarsoft.app.oci.ws.ftp;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;

import com.amarsoft.are.ARE;

public class CmdExec {

//	public static void main(String args[]) throws InterruptedException, IOException {
//		CmdExec cm = new CmdExec();
//		cm.execCmd("cmd  /c  ftp -s:C:\\Users\\T-liuyc\\Desktop\\11.cf");
//	}
//	
	/**
	 * ÷¥––cmd √¸¡Ó
	 * @param cmd
	 * @throws InterruptedException 
	 * @throws IOException 
	 */
	public void execCmd(String cmd) throws InterruptedException, IOException {
		Runtime run = Runtime.getRuntime();
		Process process = run.exec(cmd);
		
		new Thread(new Input(process.getInputStream(), "in")).run();
		new Thread(new Input(process.getErrorStream(), "err")).run();
		
		process.waitFor();
		process.destroy();
	}
	
	class Input implements Runnable {
		private InputStream is = null;
		private String type = "";
		public Input(InputStream is , String type) {
			this.is = is;
		}
		@Override
		public void run() {
			BufferedReader br = new BufferedReader(new InputStreamReader(is));
			String temp = null;
			try {
				while ((temp = br.readLine()) != null) {
					ARE.getLog().trace(type + temp);
				}
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
	}
}
