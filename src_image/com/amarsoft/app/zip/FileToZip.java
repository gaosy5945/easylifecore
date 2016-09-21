package com.amarsoft.app.zip;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

public class FileToZip {

	/**
	 * 将EndOperation文件夹下源文件，打包成fileName名称ZIP文件，并保存到zipFilePath
	 * @param sourcefilePath 待压缩的文件路径
	 * @param zipFilePath    压缩后存放路径
	 * @param fileName       压缩后文件的名称
	 * return flag
	 */
	public static boolean fileToZip(String sourceFilePath,String zipFilePath,String fileName){
		boolean flag = false;
		//定义变量
		File sourceFile = null;
		FileInputStream fis = null;
		BufferedInputStream bis = null;
		FileOutputStream fos = null;
		ZipOutputStream zos = null;
		String sourceFilePathZ[];
		String sZipFile = zipFilePath+"/"+fileName+".zip";
		try {
			
			File zipFile = new File(sZipFile);
			if(zipFile.exists()){
				System.out.println(">>>>>>>>>>>>"+ zipFilePath +" 目录下存在名字为："+ fileName +".zip 的打包文件<<<<<<<<<<<<<");
			}else{
				fos = new FileOutputStream(zipFile);
				zos = new ZipOutputStream(new BufferedOutputStream(fos));
				sourceFilePathZ = sourceFilePath.split("@");
				for(int i = 0;i < sourceFilePathZ.length;i++){
					sourceFile = new File(sourceFilePathZ[i]);
					byte[] bufs = new byte[1024*10];
					//创建ZIP实体，并添加进压缩文件
					ZipEntry zipEntry = new ZipEntry(sourceFile.getName());
					zos.putNextEntry(zipEntry);
					
					//读取待压缩的文件并写进压缩包
					fis = new FileInputStream(sourceFile);
					bis = new BufferedInputStream(fis,1024*10);
					int read = 0;
					while((read = bis.read(bufs, 0, 1024*10)) != -1){
						zos.write(bufs, 0, read);
					}
					flag = true;
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			throw new RuntimeException(e);
		}finally {
			//关闭流
			try {
				if(null != bis) bis.close();
				if(null != zos) zos.close();
			} catch (IOException e) {
				e.printStackTrace();
				throw new RuntimeException(e);
			}
		}
		
		return flag;
	}
	
	/**
	 * 文件下载
	 * @param sFilePath	文件路径
	 * @return
	 */
	public static boolean getFileDown(String sFilePath){
		boolean flag = false;
		
		return flag;
	}
	
	public static void main(String [] args){
		String sourceFilePath = "/Users/apple/Documents/Temp/als/Image/2014/11/07/20141107100840_20991289.jpeg@/Users/apple/Documents/Temp/als/Image/2014/11/07/20141107100841_36056739.jpeg";
		String zipFilePath = "/Users/apple/VirtualBox VMs/VirtualBoxOFile/";
		String fileName = "abcd";
		boolean flag = FileToZip.fileToZip(sourceFilePath, zipFilePath, fileName);
		if(flag){
			System.out.println(">>>>>>>>文件打包成功<<<<<<<<");
		}else{
			System.out.println(">>>>>>>>文件打包失败<<<<<<<<");
		}
	}
}
