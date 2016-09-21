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
				ARE.getLog().error("获得dbconfig中的  配置出错", e);
			}finally{
				try {
					rs.getStatement().close();
					ps.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
			}
		   if(iCount == 0){
			   String sCon = "该申请下无影像信息 !";
			   ServletOutputStream outStream = response.getOutputStream();
			   outStream.println(DataConvert.toRealString(3, sCon));
			   outStream.flush();
			   outStream.close();
		   }else{
			   String sPath = getFileName(sObjectNo,sObjectType,conn);
			   String sFilePath[] = sPath.split("@");
			   String sFileName = StringFunction.getFileName(sFilePath[0]);
			  //创建要下载的文件的对象(参数为要下载的文件在服务器上的路径)
			   File serverFile=new File(sFilePath[0]);
			   
			   //设置要显示在保存窗口的文件名，如果文件名中有中文的话，则要设置字符集，否则会出现乱码。另外，要写上文件后缀名
			   String fileName=java.net.URLEncoder.encode(sFileName,"utf-8");
			   //该步是最关键的一步，使用setHeader()方法弹出"是否要保存"的对话框，打引号的部分都是固定的值，不要改变
			   response.setHeader("Content-disposition","attachment;filename="+fileName);
			  
			   /*
			    * 以下四行代码经测试似乎可有可无，可能是我测试的文件太小或者其他什么原因。。。
			    */
			   response.setContentType("application/zip");
			   //定义下载文件的长度 /字节
			   long fileLength=serverFile.length();
			   //把长整形的文件长度转换为字符串
			   String length=String.valueOf(fileLength);
			   //设置文件长度(如果是Post请求，则这步不可少)
			   response.setHeader("content_Length",length);
			   
			   /*
			    *以上内容仅是下载一个空文件
			    *以下内容用于将服务器中相应的文件内容以流的形式写入到该空文件中
			    */
	           //获得一个 ServletOutputStream(向客户端发送二进制数据的输出流)对象
			   OutputStream servletOutPutStream=response.getOutputStream();
			   //获得一个从服务器上的文件myFile中获得输入字节的输入流对象
			   FileInputStream fileInputStream=new FileInputStream(serverFile);
			   
			   
			   byte bytes[]=new byte[1024];//设置缓冲区为1024个字节，即1KB
			   int len=0;
			   //读取数据。返回值为读入缓冲区的字节总数,如果到达文件末尾，则返回-1
			   while((len=fileInputStream.read(bytes))!=-1)
			   {   
				   //将指定 byte数组中从下标 0 开始的 len个字节写入此文件输出流,(即读了多少就写入多少)
				   servletOutPutStream.write(bytes,0,len); 
			   }
			   
			   servletOutPutStream.close();
			   fileInputStream.close();	
		   }
	}
	
	/**
	 * 获取文件，zip
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
		ARE.getLog().info("打包["+sObjectNo+"]申请下的影像信息！");
		try{
			ps = conn.prepareStatement("select DocumentID from Ecm_Page where ObjectNo = '"+sObjectNo+"' and ObjectType = '"+sObjectType+"' ");
			ARE.getLog().warn("需要打包文件SQL：select DocumentID from Ecm_Page where ObjectNo = '"+sObjectNo+"' and ObjectType = '"+sObjectType+"'");
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
				ARE.getLog().warn("成功将［"+sObjectNo+"］申请下的影像信息保存到［"+folderStr+"］目录下，文件名为："+sZipName);
				sFileName = folderStr+"/"+sZipName+".zip"+"@"+sZipName+".zip";
			}else{
				ARE.getLog().warn("保存［"+sObjectNo+"］申请下的影像信息保存到［"+folderStr+"］目录下失败！");
			}
		}catch(Exception e){
			ARE.getLog().warn("文件打包失败！");
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
