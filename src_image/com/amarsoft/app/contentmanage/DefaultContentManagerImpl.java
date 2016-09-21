package com.amarsoft.app.contentmanage;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Properties;

import com.amarsoft.are.ARE;
import com.amarsoft.are.lang.DateX;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.are.sql.Connection;
import com.amarsoft.are.sql.ConnectionManager;
import com.amarsoft.are.sql.Query;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.Configure;
//import com.amarsoft.awe.Configure;
import com.amarsoft.awe.util.Transaction;

/**
 * 缺省的内容管理实现类: 实现上传文档、下载文档、删除文档; 
 */
public class DefaultContentManagerImpl  implements ContentManager{
	/*private static String dbName = "oradb";*/
	private static String dbName = "als";
	//用于格式化日期
	private SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
	/*mimeTypes配置文件*/
	private static Properties mimeTypes= null;
	/*加载mimeTypes配置文件*/
	static{
		String filepath = ARE.getProperty("APP_HOME")+"/etc/MimeTypes.properties";
		mimeTypes =  new Properties();
		try {
			//dbName = Configure.getInstance().getConfigure("DataSource");
			dbName = Configure.getInstance().getConfigure("DataSource");
			mimeTypes.load(new FileInputStream(filepath));
		} catch (IOException e) {
			ARE.getLog().error("load附件的MimeTypes配置出错", e);
		} catch (Exception e) {
			ARE.getLog().error("获取awe配置的dbName出错", e);
		}
	}
	@Override
	public Content get(String path) {
		if(StringX.isEmpty(path)) return null;
		Runtime rt = Runtime.getRuntime();
		System.out.println("开始批量扫描影像，内存总量:"+rt.totalMemory()+"，内存剩余："+rt.freeMemory());
		Content content = null;
		File f = new File(path);
		if(f.exists() && f.isFile()){
			content = new Content();
			content.setId(path);
			content.setName(f.getName());
			content.setSize(f.length());
			content.setVersion("1");
			content.setCreateDate(sdf.format(new Date(f.lastModified())));
			content.setContentType(mimeTypes.getProperty(f.getName().substring(f.getName().lastIndexOf(".")+1)));
			String desc = null;
			Statement stat =null;
			Connection conn = null;
			ResultSet rs = null;
			try {
				/*javax.sql.DataSource ds = ConnectionManager.getDataSource(dbName);*/
				Transaction Sqlca = new Transaction(dbName);
				conn = Sqlca.getConnection();
				/*conn = ConnectionManager.getTransaction(ds).conn;*/
				stat = conn.createStatement();
				rs = stat.executeQuery("select remark from ECM_PAGE where documentId='"+path+"'");
				if(rs.next()){
					desc = rs.getString("remark");
				}
				rs.close();
			} catch (Exception e1) {
				e1.printStackTrace();
			} finally{
				try{
					if(rs!=null) rs.close();
					if(stat!=null) stat.close();
					if(conn!=null) conn.close();
				}catch(Exception e){ARE.getLog().trace("释放数据连接出错");}
			}
			content.setDesc(desc==null?"":desc);
			try {
				content.setInputStream(new FileInputStream(f));
			} catch (FileNotFoundException e) {
				e.printStackTrace();
			}
		}
		System.out.println("开始批量扫描影像，内存总量:"+rt.totalMemory()+"，内存剩余："+rt.freeMemory());
		return content;
	}
	@Override
	public String save(Content content, int folderType,String ObjectNo) {
		Runtime rt = Runtime.getRuntime();
		if(content==null || 
				StringX.isEmpty(content.getId()) && content.getInputStream()==null ){return null;}
		String folderStr = null;
		String filePath = null;
		String today = DateX.format(new Date(), "yyyy/MMdd");
		try {
			
			System.out.println(StringFunction.getNow()+"======上传影像图片开始，内存总量:"+rt.totalMemory()+"，内存剩余："+rt.freeMemory());
			folderStr = Configure.getInstance().getConfigure("ImageFolder");
			if(StringX.isEmpty(folderStr)) {
				throw new Exception("当前使用缺省的内容管理实现类,但awe配置文件中未配置影像文件夹ImageFolder!");
			}
			folderStr = folderStr+"/"+today+"/"+ObjectNo;
			File folder = new File(folderStr);
			if(! folder.exists()){
				folder.mkdirs();
			}
			filePath = folderStr+"/"+content.getName();
			System.out.println("-------------------"+filePath);
			File f = new File(filePath);
			FileOutputStream fos = new FileOutputStream(f);
			byte[] b = new byte[1024];
			int k = -1;
			while( (k=content.getInputStream().read(b)) >0){
				fos.write(b, 0, k);
			}
			content.getInputStream().close();
			fos.flush();
			fos.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		System.out.println(StringFunction.getNow()+"======上传影像图片结束，内存总量:"+rt.totalMemory()+"，内存剩余："+rt.freeMemory()+"，文件名称："+filePath);
		return filePath;
	}
	
	@Override
	public boolean setDesc(String path, String desc ){
		return true;
	}
	@Override
	public boolean delete(String path) {
		File f = new File(path);
		if(f.exists()){
			f.delete();
		}
		return true;
	}
	@Override
	public String newVersion(String path, Content content) {
		return null;
	}
	@Override
	public List<Content> getAllVersions(String id) {
		return null;
	}
	
	@Override
	public boolean delAllVersion(String id) {
		return true;
	}
	

}
