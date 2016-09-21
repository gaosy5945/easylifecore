package com.amarsoft.app.zip;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.amarsoft.are.sql.Connection;
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.are.ARE;
import com.amarsoft.awe.Configure;

public class DownFile extends HttpServlet{

	public void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		   String sObjectNo =request.getParameter("ObjectNo");
		   String sObjectType =request.getParameter("ObjectType");
		   Connection conn = null;
		   PreparedStatement ps=null;
		   ResultSet rs = null;
		   String dataSource = "oradb";
		   int iCount = 0;
		   try {
				conn = ARE.getDBConnection(dataSource);
				conn.setAutoCommit(false);
				ps = conn.prepareStatement("select count(1) as iCount from Ecm_Page where ObjectNo = '"+sObjectNo+"' and ObjectType = '"+sObjectType+"' ");
				rs = ps.executeQuery();
				while(rs.next()){
					iCount = rs.getInt("iCount");
				}
			} catch (Exception e) {
				ARE.getLog().error("���dbconfig�е�  ���ó���", e);
			}finally{
				try {
					rs.getStatement().close();
					ps.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
			}
		   if(iCount == 0){
			   String sCon = "����������Ӱ����Ϣ !";
			   ServletOutputStream outStream = response.getOutputStream();
			   outStream.println(DataConvert.toRealString(3, sCon));
			   outStream.flush();
			   outStream.close();
		   }else{
			   String sPath = getFileName(sObjectNo,sObjectType,conn);
			   String sFilePath[] = sPath.split("@");
			   String sFileName = StringFunction.getFileName(sFilePath[0]);
			  //����Ҫ���ص��ļ��Ķ���(����ΪҪ���ص��ļ��ڷ������ϵ�·��)
			   File serverFile=new File(sFilePath[0]);
			   
			   //����Ҫ��ʾ�ڱ��洰�ڵ��ļ���������ļ����������ĵĻ�����Ҫ�����ַ����������������롣���⣬Ҫд���ļ���׺��
			   String fileName=java.net.URLEncoder.encode(sFileName,"utf-8");
			   //�ò�����ؼ���һ����ʹ��setHeader()��������"�Ƿ�Ҫ����"�ĶԻ��򣬴����ŵĲ��ֶ��ǹ̶���ֵ����Ҫ�ı�
			   response.setHeader("Content-disposition","attachment;filename="+fileName);
			  
			   /*
			    * �������д��뾭�����ƺ����п��ޣ��������Ҳ��Ե��ļ�̫С��������ʲôԭ�򡣡���
			    */
			   response.setContentType("application/zip");
			   //���������ļ��ĳ��� /�ֽ�
			   long fileLength=serverFile.length();
			   //�ѳ����ε��ļ�����ת��Ϊ�ַ���
			   String length=String.valueOf(fileLength);
			   //�����ļ�����(�����Post�������ⲽ������)
			   response.setHeader("content_Length",length);
			   
			   /*
			    *�������ݽ�������һ�����ļ�
			    *�����������ڽ�����������Ӧ���ļ�������������ʽд�뵽�ÿ��ļ���
			    */
	           //���һ�� ServletOutputStream(��ͻ��˷��Ͷ��������ݵ������)����
			   OutputStream servletOutPutStream=response.getOutputStream();
			   //���һ���ӷ������ϵ��ļ�myFile�л�������ֽڵ�����������
			   FileInputStream fileInputStream=new FileInputStream(serverFile);
			   
			   
			   byte bytes[]=new byte[1024];//���û�����Ϊ1024���ֽڣ���1KB
			   int len=0;
			   //��ȡ���ݡ�����ֵΪ���뻺�������ֽ�����,��������ļ�ĩβ���򷵻�-1
			   while((len=fileInputStream.read(bytes))!=-1)
			   {   
				   //��ָ�� byte�����д��±� 0 ��ʼ�� len���ֽ�д����ļ������,(�����˶��پ�д�����)
				   servletOutPutStream.write(bytes,0,len); 
			   }
			   
			   servletOutPutStream.close();
			   fileInputStream.close();	
		   }
	}
	
	/**
	 * ��ȡ�ļ���zip
	 * @param sObjectNo
	 * @param sObjectType
	 * @return
	 */
	public static String getFileName(String sObjectNo,String sObjectType,Connection conn){
		String sFileName = "";
		String sZipName = "";
		String sFilePath = "";
		boolean flag;
		String folderStr = null;
		PreparedStatement ps=null;
		ResultSet rs = null;
		ARE.getLog().info("���["+sObjectNo+"]�����µ�Ӱ����Ϣ��");
		try{
			ps = conn.prepareStatement("select DocumentID from Ecm_Page where ObjectNo = '"+sObjectNo+"' and ObjectType = '"+sObjectType+"' ");
			ARE.getLog().warn("��Ҫ����ļ�SQL��select DocumentID from Ecm_Page where ObjectNo = '"+sObjectNo+"' and ObjectType = '"+sObjectType+"'");
			rs = ps.executeQuery();
			while(rs.next()){
				sFilePath += rs.getString("DocumentID")+"@";
			}
			sFilePath = sFilePath.substring(0, sFilePath.length()-1);
			sZipName = sObjectNo+"_"+String.valueOf(System.currentTimeMillis());
			FileToZip zip = new FileToZip();
			folderStr = Configure.getInstance().getConfigure("ZipDownPath");
			flag = zip.fileToZip(sFilePath, folderStr, sZipName);
			if(flag){
				ARE.getLog().warn("�ɹ�����"+sObjectNo+"�������µ�Ӱ����Ϣ���浽��"+folderStr+"��Ŀ¼�£��ļ���Ϊ��"+sZipName);
				sFileName = folderStr+"/"+sZipName+".zip"+"@"+sZipName+".zip";
			}else{
				ARE.getLog().warn("�����"+sObjectNo+"�������µ�Ӱ����Ϣ���浽��"+folderStr+"��Ŀ¼��ʧ�ܣ�");
			}
		}catch(Exception e){
			ARE.getLog().warn("�ļ����ʧ�ܣ�");
		}finally{
			try {
				rs.getStatement().close();
				ps.close();
				conn.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		
		
		return sFileName;
	}


}
