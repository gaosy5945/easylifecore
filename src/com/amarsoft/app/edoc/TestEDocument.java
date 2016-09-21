/**
 * File Created 2008-1-4 下午03:19:43.
 */
package com.amarsoft.app.edoc;

import java.io.File;
import java.io.IOException;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.HashMap;

import org.jdom.JDOMException;

import com.amarsoft.are.ARE;
import com.amarsoft.are.sql.ConnectionManager;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

/**
 * @author fmwu
 * 
 */
public class TestEDocument {

	public static Transaction getSqlca() throws Exception {
		String  appHome = "D:/workspace/web/WebContent/WEB-INF";
		ARE.setProperty("APP_HOME", appHome);
		ARE.init(appHome + "/etc/are.xml");
		Transaction sqlca = new Transaction("als");
		return sqlca;
	}
	
	public static void getDoc(String modeCode,String serialNo) throws Exception{		
		String docPath = null;
		Transaction sqlca = null;
		try {
			sqlca = getSqlca();		
			docPath = sqlca.getString(new SqlObject("select fullpathfmt from pub_edoc_config where edocNo ="+modeCode));
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} 
		//String xmlPath =  sqlca.getString(new SqlObject("select fullpathdef from pub_edoc_config where edocNo ="+modeCode));
		//找到doc文件名
		String fileName = docPath.substring(docPath.lastIndexOf("/")+1,docPath.indexOf(".doc"));
		ARE.getLog().trace("doc文件名为"+fileName);
		//截取父文件夹的路径
		String filePath = docPath.substring(0,docPath.lastIndexOf("/")+1);
		ARE.getLog().trace("父文件夹名为"+filePath);
	    File file = new File(filePath);
	    	File[] files = file.listFiles();
		if(files!=null){
	    	for(File f: files){
		    	//找到相应的doc文件
		    	if(f.getName().indexOf(fileName)!=-1&&f.getName().indexOf(".doc")==f.getName().length()-4){            
		    		String subName = f.getName().substring(0,f.getName().indexOf(".doc"));	    		
		    		String xmlName = subName+".xml";
		    		//输出文件路径
		    		String outName = "D:\\"+f.getName();
		    		//doc文件路径
		    		String docFilePath = filePath+f.getName();
		    		//找到相应的xml文件路径
		    		String xmlPath = filePath+subName+".xml";
		    		if(new File(xmlPath).exists()){
		    			EDocument edoc = new EDocument(docFilePath, xmlPath);
			    		if (sqlca != null) {
			    			HashMap map = new HashMap();
			    			map.put("SerialNo",serialNo);
			    			map.put("EdocNo",modeCode);
			    			edoc.saveDoc(outName, map, sqlca);
			    			sqlca.disConnect();
			    		}
			    		ARE.getLog().trace("success:OutFName=" + outName);
		    		}		    		
		    	}
		    }
	    }	    
	}
	
	public static void testEDoc() throws Exception {
		//生成的数据文件
		//生成模板doc
//		String sTemplateFName = "../docs/05.系统开发/电子合同文档/个人担保借款合同/04个人担保借款合同07.doc";
//		//生成模板xml
//		String sDataDefFName = "../docs/05.系统开发/电子合同文档/个人担保借款合同/04个人担保借款合同07.xml";
		
//		//生成模板doc
//		String sTemplateFName = "../docs/05.系统开发/电子合同文档/个人购房贷款合同/01个人购房贷款合同03.doc";
//		//生成模板xml
//		String sDataDefFName = "../docs/05.系统开发/电子合同文档/个人购房贷款合同/01个人购房贷款合同03.xml";
//		
//		//生成模板doc
//		String sTemplateFName = "../docs/05.系统开发/电子合同文档/个人授信合同/02个人授信合同02.doc";
//		//生成模板xml
//		String sDataDefFName = "../docs/05.系统开发/电子合同文档/个人授信合同/02个人授信合同02.xml";
		
		String sTemplateFName = "../docs/05.系统开发/电子合同文档/个人购房担保借款合同/05个人购房担保借款合同03.doc";
		//生成模板xml
		String sDataDefFName = "../docs/05.系统开发/电子合同文档/个人购房担保借款合同/05个人购房担保借款合同03.xml";
		
		  int end = sTemplateFName.indexOf(".doc");
		  int start = sTemplateFName.lastIndexOf("/");
		  String DocPartName = sTemplateFName.substring(start+1,end);
		  
		  java.util.Date dateNow = new java.util.Date();
		  SimpleDateFormat sdfTemp = new SimpleDateFormat("yyyy-MM-dd-hh-mm-ss");
		  String sBeginTime=sdfTemp.format(dateNow);
		 String sOutDocName = "D:/"+DocPartName+"--"+sBeginTime+".doc";

		 //String sOutDocName = "D:/"+sBeginTime+".doc";
		
		

		EDocument edoc = new EDocument(sTemplateFName, sDataDefFName);
		Transaction Sqlca = getSqlca();
		if (Sqlca != null) {
			HashMap map = new HashMap();
			map.put("SerialNo","2014121600000001");
			map.put("EdocNo","2014112900000008");
			edoc.saveDoc(sOutDocName, map, Sqlca);
			Sqlca.disConnect();
		}
	}

	public static void testStamper() throws Exception {
		String sTemplateFName = "src/com/amarsoft/app/edoc/两方签章页.doc";
		String sDataDefFName = "src/com/amarsoft/app/edoc/签章页定义.xml";
		String sOutDocName = "C:/tmp/edoc/电子签章页（两方）.doc";
		String sOutXmlName = "C:/tmp/edoc/签章页数据.xml";
		String sOutDefalutName = "C:/tmp/edoc/两方签章页.doc";

		EDocument edoc = new EDocument(sTemplateFName, sDataDefFName);
		edoc.saveAsDefault(sOutDefalutName);
		HashMap map = new HashMap();
		map.put("EDocName", "    借款合同");
		map.put("CustomerName", "深圳市新世界集团有限公司");
		map.put("ContractID", "C1001101010800028");
	}
	
	/**
	 * @param args	
	 */
	public static void main(String[] args) {
		try {
			TestEDocument.testEDoc();
			//TestEDocument.testStamper();
//			String modeCode = "2014112900000009";
//			String serialNo = "2014121600000001";
//			TestEDocument.getDoc(modeCode,serialNo);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
