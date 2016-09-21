package com.amarsoft.app.oci.ws.ftp;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.util.Date;
import java.util.List;
import java.util.Properties;


public class FtpTool {
	private Enum<SystemCatalog> os = null;
	private String host = null;
	private String name = null;
	private String password = null;
	
	public FtpTool(String host, String name, String password) {
		recognizeSystem();
		this.host = host;
		this.name = name;
		this.password = password;
	}
	
	private void recognizeSystem() {
		Properties property = System.getProperties();
		String name = property.getProperty("os.name");
		if (name.toLowerCase().startsWith("win"))
			os = SystemCatalog.Window;
		else
			os = SystemCatalog.Linux;
	}
	
	public void download(List<String> fileNameList, String ftpLoaction, String localLocation) throws IOException, InterruptedException {
		if (os.equals(SystemCatalog.Window)) {
			downWin(fileNameList, ftpLoaction, localLocation);
		} else {
			downLinxu(fileNameList, ftpLoaction, localLocation);
		}
	}
	
	public void upload(List<String> fileNameList, String ftpLoaction, String localLocation) throws IOException, InterruptedException {
		if (os.equals(SystemCatalog.Window)) {
			upWin(fileNameList, ftpLoaction, localLocation);
		} else {
			upLinxu(fileNameList, ftpLoaction, localLocation);
		}
	}



	private void downWin(List<String> fileNameList, String sourceLoaction,
			String targetLocation) throws FileNotFoundException, IOException, InterruptedException {
		String fileName = new Date().getTime() + Math.round(Math.random()*1000) + "";
		File file = new File(fileName);
		FileOutputStream fos = new FileOutputStream(file, false);
		BufferedWriter bw = new BufferedWriter(new OutputStreamWriter(fos));
		bw.write("open " + host );
		bw.newLine();
		bw.write(name);
		bw.newLine();
		bw.write(password);
		bw.newLine();
		bw.write("bin");
		bw.newLine();
		bw.write("cd " + sourceLoaction);
		bw.newLine();
		bw.write("lcd " + targetLocation);
		bw.newLine();
		bw.write("prom off");
		bw.newLine();
		for (String name : fileNameList){
			bw.write("mget " + name);
			bw.newLine();
		}
		bw.write("quit");
		bw.newLine();
		bw.flush();
		bw.close();
		new CmdExec().execCmd("cmd  /c  ftp -s:" + fileName);
		file.delete();
	}
	
	private void downLinxu(List<String> fileNameList, String ftpLoaction, String localLocation) throws IOException, InterruptedException {
		String fileName = new Date().getTime() + Math.round(Math.random()*1000) + ".sh";
		File file = new File(fileName);
		FileOutputStream fos = new FileOutputStream(file, false);
		BufferedWriter bw = new BufferedWriter(new OutputStreamWriter(fos));
		bw.write("ftp  -n<<!");
		bw.newLine();
		bw.write("open " + host );
		bw.newLine();
		bw.write("user " + name + " " + password);
		bw.newLine();
		bw.write("bin");
		bw.newLine();
		bw.write("cd " + ftpLoaction);
		bw.newLine();
		bw.write("lcd " + localLocation);
		bw.newLine();
		bw.write("prom off");
		bw.newLine();
		for (String name : fileNameList){
			bw.write("mget " + name);
			bw.newLine();
		}
		bw.write("quit");
		bw.newLine();
		bw.flush();
		bw.close();
		new CmdExec().execCmd("sh " + fileName);
		file.delete();
	}
	
	private void upWin(List<String> fileNameList, String sourceLoaction,
			String targetLocation) throws IOException, InterruptedException {
		String fileName = new Date().getTime() + Math.round(Math.random()*1000) + "";
		File file = new File(fileName);
		FileOutputStream fos = new FileOutputStream(file, false);
		BufferedWriter bw = new BufferedWriter(new OutputStreamWriter(fos));
		bw.write("open " + host );
		bw.newLine();
		bw.write(name);
		bw.newLine();
		bw.write(password);
		bw.newLine();
		bw.write("bin");
		bw.newLine();
		bw.write("cd " + sourceLoaction);
		bw.newLine();
		bw.write("lcd " + targetLocation);
		bw.newLine();
		bw.write("prom off");
		bw.newLine();
		for (String name : fileNameList){
			bw.write("mput " + name);
			bw.newLine();
		}
		bw.write("quit");
		bw.newLine();
		bw.flush();
		bw.close();
		new CmdExec().execCmd("cmd  /c  ftp -s:" + fileName);
		file.delete();
	}

	private void upLinxu(List<String> fileNameList, String ftpLoaction, String localLocation) throws IOException, InterruptedException {
		String fileName = new Date().getTime() + Math.round(Math.random()*1000) + ".sh";
		File file = new File(fileName);
		FileOutputStream fos = new FileOutputStream(file, false);
		BufferedWriter bw = new BufferedWriter(new OutputStreamWriter(fos));
		bw.write("ftp  -n<<!");
		bw.newLine();
		bw.write("open " + host );
		bw.newLine();
		bw.write("user " + name + " " + password);
		bw.newLine();
		bw.write("bin");
		bw.newLine();
		bw.write("cd " + ftpLoaction);
		bw.newLine();
		bw.write("lcd " + localLocation);
		bw.newLine();
		bw.write("prom off");
		bw.newLine();
		for (String name : fileNameList){
			bw.write("mput " + name);
			bw.newLine();
		}
		bw.write("quit");
		bw.newLine();
		bw.flush();
		bw.close();
		new CmdExec().execCmd("sh " + fileName);
		file.delete();
	}
}
