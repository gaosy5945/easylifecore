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
	 * ��EndOperation�ļ�����Դ�ļ��������fileName����ZIP�ļ��������浽zipFilePath
	 * @param sourcefilePath ��ѹ�����ļ�·��
	 * @param zipFilePath    ѹ������·��
	 * @param fileName       ѹ�����ļ�������
	 * return flag
	 */
	public static boolean fileToZip(String sourceFilePath,String zipFilePath,String fileName){
		boolean flag = false;
		//�������
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
				System.out.println(">>>>>>>>>>>>"+ zipFilePath +" Ŀ¼�´�������Ϊ��"+ fileName +".zip �Ĵ���ļ�<<<<<<<<<<<<<");
			}else{
				fos = new FileOutputStream(zipFile);
				zos = new ZipOutputStream(new BufferedOutputStream(fos));
				sourceFilePathZ = sourceFilePath.split("@");
				for(int i = 0;i < sourceFilePathZ.length;i++){
					sourceFile = new File(sourceFilePathZ[i]);
					byte[] bufs = new byte[1024*10];
					//����ZIPʵ�壬����ӽ�ѹ���ļ�
					ZipEntry zipEntry = new ZipEntry(sourceFile.getName());
					zos.putNextEntry(zipEntry);
					
					//��ȡ��ѹ�����ļ���д��ѹ����
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
			//�ر���
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
	 * �ļ�����
	 * @param sFilePath	�ļ�·��
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
			System.out.println(">>>>>>>>�ļ�����ɹ�<<<<<<<<");
		}else{
			System.out.println(">>>>>>>>�ļ����ʧ��<<<<<<<<");
		}
	}
}
