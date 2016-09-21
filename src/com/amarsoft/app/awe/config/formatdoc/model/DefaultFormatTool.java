package com.amarsoft.app.awe.config.formatdoc.model;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;

import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.DateX;
import com.amarsoft.awe.common.pdf.Html2Pdf;
import com.amarsoft.biz.formatdoc.model.AmarDocParser;
import com.amarsoft.biz.formatdoc.model.FormatDocConfig;
import com.amarsoft.biz.formatdoc.model.FormatDocData;
import com.amarsoft.biz.formatdoc.model.FormatDocHelp;
import com.amarsoft.biz.formatdoc.model.IFormatDocData;
import com.amarsoft.biz.formatdoc.model.IFormatTool;
import com.amarsoft.biz.formatdoc.offlinegenerator.ContentHtmlGenerator;
import com.amarsoft.biz.formatdoc.offlinegenerator.MainHtmlGenerator;
import com.amarsoft.biz.formatdoc.offlinegenerator.MenuHtmlGenerator;
import com.amarsoft.biz.formatdoc.offlinegenerator.RightHtmlGenerator;
import com.amarsoft.context.ASUser;

/**
 * @des 生成报告工具类默认实现类
 *     
 *      1.该类中没有加入时事务的处理
 * 		3.缺少格式化报告节点自定义设置
 * @author bwang1
 *
 */
public class DefaultFormatTool implements IFormatTool{
	
	protected String[] excludeDirIds = new String[0];
	
	private boolean isExclude(String dirid){
		for(int i=0;i<excludeDirIds.length;i++){
			if(excludeDirIds[i].equals(dirid))
				return true;
		}
		return false;
	}

	/**
	 * 设置排除节点,多个排除节点以逗号分隔
	 * @param excludeDirIds
	 */
	public void setExcludeDirIds(String excludeDirIds) {
		if(excludeDirIds==null || excludeDirIds.trim().length()==0)return;
		this.excludeDirIds = excludeDirIds.split("\\,");
	}
	/**
	 * 新增一笔格式化报告(适用于授信业务流程中的相关报告，如公司授信贷前调查报告)
	 * 
	 * @param asUser:当前用户
	 * @param sObjectType:对象类型
	 * @param sObjectNo:业务流水号
	 * @param sDocID:调查报告文档类别
	 * @return true/false: 成功或失败
	 * @throws JBOException 
	 */
	public boolean newDocument(ASUser asUser,String sObjectType,String sObjectNo,String sDocID) throws JBOException {
		//JBOTransaction tx = JBOFactory.getFactory().createTransaction();
		String today = DateX.format(new java.util.Date());
		JBOTransaction tx = JBOFactory.getFactory().createTransaction();
		try {
			JBOFactory factory = JBOFactory.getFactory();

			BizObjectManager bmRecord = factory.getManager("jbo.app.FORMATDOC_RECORD",tx);
			//tx.join(bmRecord);
			//String sSerialNo = DBKeyHelp.getSerialNo("AWE_ERPT_RECORD","SERIALNO",new Transaction(bmRecord.getDatabase()));
			BizObject boRecord = bmRecord.newObject();
			//boRecord.setAttributeValue("SERIALNO", sSerialNo);
			boRecord.setAttributeValue("OBJECTTYPE", sObjectType);
			boRecord.setAttributeValue("OBJECTNO", sObjectNo);
			boRecord.setAttributeValue("DOCID", sDocID);
			boRecord.setAttributeValue("ORGID", asUser.getOrgID());
			boRecord.setAttributeValue("USERID", asUser.getUserID());
			boRecord.setAttributeValue("INPUTDATE", today);
			boRecord.setAttributeValue("UPDATEDATE", today);
			boRecord.setAttributeValue("OFFLINEVERSION", 0);
			bmRecord.saveObject(boRecord);
			
			BizObjectManager bmData = factory.getManager("jbo.app.FORMATDOC_DATA",tx);
			BizObjectManager bmDef = factory.getManager("jbo.app.FORMATDOC_DEF",tx);
			BizObjectQuery bqDef = bmDef.createQuery("select DOCID,DIRID,DIRNAME,JSPFILENAME,HTMLFILENAME,ARRANGEATTR,CIRCLEATTR,ATTRIBUTE1 from O where DOCID=:docid").
						setParameter("docid", sDocID);
			List lboDef = bqDef.getResultList(true);
			for(int i=0;i<lboDef.size();i++){
				BizObject boDef = (BizObject)lboDef.get(i);
				//如果在排除字段中则跳过
				if(this.isExclude(boDef.getAttribute("DIRID").getString()))
					continue;
				if(boDef.getAttribute("CIRCLEATTR").getValue()!=null && !boDef.getAttribute("CIRCLEATTR").getString().equals("0") && boDef.getAttribute("CIRCLEATTR").getString().trim().length()>0)
					continue;
				BizObject boData = bmData.newObject();
				//boData.setAttributeValue("OBJECTNO", sObjectNo);
				boData.setAttributeValue("RELATIVESERIALNO",boRecord.getAttribute("SERIALNO").getString());
				boData.setAttributeValue("TREENO",boDef.getAttribute("DIRID").getString());
				boData.setAttributeValue("DOCID",sDocID);
				boData.setAttributeValue("DIRID",boDef.getAttribute("DIRID").getString());
				boData.setAttributeValue("DIRNAME",boDef.getAttribute("DIRNAME").getString());
				boData.setAttributeValue("CONTENTLENGTH",0);
				boData.setAttributeValue("ORGID",asUser.getOrgID());
				boData.setAttributeValue("USERID",asUser.getUserID());
				boData.setAttributeValue("INPUTDATE", today);
				boData.setAttributeValue("UPDATEDATE", today);
				bmData.saveObject(boData);
			}
			
			updateNeedFlag(asUser,sObjectType,sObjectNo,sDocID);
			tx.commit();
		} catch (Exception e) {
			tx.rollback();
			e.printStackTrace();
			return false;
		}
		return true;
		
	}
	/**
	 * 刷新一笔格式化报告的目录(适用于授信业务流程中的相关报告，如公司授信贷前调查报告)
	 * 
	 * @param asUser:当前用户
	 * @param sObjectType:对象类型
	 * @param sObjectNo:业务流水号
	 * @param sDocID:调查报告文档类别
	 * @return true/false: 成功或失败
	 * @throws JBOException 
	 */
	public boolean refreshDocument(ASUser asUser,String sObjectType,String sObjectNo,String sDocID ){
		JBOTransaction tx = null;
		try{
			tx=JBOFactory.getFactory().createTransaction();
			updateNeedFlag(asUser,sObjectType,sObjectNo,sDocID);
			tx.commit();
			return true;
		} catch (Exception e) {
			try{
				if(tx!=null)tx.rollback();
			}
			catch(Exception ex){ex.printStackTrace();}
			e.printStackTrace();
			return false;
		}
	}
	
	/**
	 * 刷新一笔格式化报告的数据
	 * 
	 * @param sObjectType:对象类型
	 * @param sObjectNo:业务流水号
	 * @param sDocID:调查报告文档类别:docid
	 * @param config 格式化配置
	 * @return true/false: 成功或失败
	 * @throws JBOException 
	 */
	public boolean refreshDocumentData(String sObjectType,String sObjectNo,String sDocID,FormatDocConfig config){
		try{
			BizObjectManager bmData = JBOFactory.getFactory().getManager("jbo.app.FORMATDOC_DATA");
			List list = bmData.createQuery("select o.serialno from jbo.app.FORMATDOC_RECORD r,o where o.RELATIVESERIALNO=r.SERIALNO and r.objectno=:objectno and r.objecttype=:objecttype and r.docid=:docid")
				.setParameter("objectno", sObjectNo).setParameter("objecttype", sObjectType).setParameter("docid", sDocID)
				.getResultList(false);
			if(list!=null){
				for(int i=0;i<list.size();i++){
					BizObject obj = (BizObject)list.get(i);
					IFormatDocData  data = FormatDocHelp.getFDDataObject(obj.getAttribute("serialno").getString(), "com.amarsoft.app", config);
					if(data==null)continue;
					if(data.forceRefreshObject()==false)return false;
				}
			}
			return true;
		}catch(Exception e){
			e.printStackTrace();
			return false;
		}
	}
	
	/**
	 * 判断是否已经存在报告
	 * 
	 * @param asUser:当前用户
	 * @param sObjectType:对象类型
	 * @param sObjectNo:业务流水号
	 * @param sDocID:调查报告文档类别
	 * @return true/false: 存在或不存在
	 * @throws JBOException 
	 */
	public boolean existDocument(ASUser asUser,String sObjectType,String sObjectNo,String sDocID ) throws JBOException {
		int iCount = 0; //判断是否是初次生成报告
		BizObjectQuery bq = JBOFactory.createBizObjectQuery("jbo.app.FORMATDOC_RECORD", "ObjectType = :objecttype and ObjectNo = :objectno and DocID = :docid ");
		bq.setParameter("objecttype",sObjectType).setParameter("objectno",sObjectNo).setParameter("docid",sDocID);
		iCount = bq.getTotalCount();
		
		return iCount>0 ? true : false ;
	}

	/**
	 * 得到报告目录的第一个节点ID
	 * 
	 * @param asUser:当前用户
	 * @param sObjectType:对象类型
	 * @param sObjectNo:业务流水号
	 * @param sDocID:调查报告文档类别
	 * @return 报告目录的第一个节点ID
	 * @throws JBOException 
	 */
	public String getFirstNodeID(ASUser asUser,String sObjectType,String sObjectNo,String sDocID ) throws JBOException {
		String sFirstNodeID = ""; 
		
		BizObjectManager bm = JBOFactory.getFactory().getManager("jbo.app.FORMATDOC_DATA");
		BizObjectQuery bq = bm.createQuery("select SerialNo from O where relativeserialno in (select fr.serialno from jbo.app.FORMATDOC_RECORD fr where fr.ObjectType = :objecttype and fr.ObjectNo = :objectno and fr.DocID = :docid) order by TreeNo ");
		bq.setParameter("objecttype",sObjectType).setParameter("objectno",sObjectNo).setParameter("docid",sDocID);
		BizObject bo = bq.getSingleResult(false);
		if(bo != null){
			sFirstNodeID = bo.getAttribute("SerialNo").getString();
		}
		
		return sFirstNodeID ;
	}
	
	public void deleteDocument() {

	}
	
	/**
	 * 将格式化报告生成pdf文件
	 * @param config 格式化报告参数配置对象
	 * @param sObjectType 对象类型
	 * @param sObjectNo 业务流水号
	 * @param sDocID 调查报告文档类别
	 * @return
	 * @throws Exception
	 */
	public String genPdf(FormatDocConfig config,String sObjectType,String sObjectNo,String sDocID)throws Exception{
		BizObjectManager bmRecord = JBOFactory.getFactory().getManager("jbo.app.FORMATDOC_RECORD");
		BizObjectQuery bqRecord = bmRecord.createQuery("select SAVEPATH from O where ObjectType = :objecttype and ObjectNo = :objectno and DocID = :docid ").
				setParameter("objecttype",sObjectType).setParameter("objectno",sObjectNo).setParameter("docid",sDocID);
		BizObject boRecord = bqRecord.getSingleResult(false);
		String sHtmlFileName = boRecord.getAttribute("SAVEPATH").getString();
		if(sHtmlFileName == null) sHtmlFileName = "";
		String sPdfFileName = sHtmlFileName.substring(0, sHtmlFileName.lastIndexOf(".")) + ".pdf";
		Html2Pdf.FONTS_DIR = config.getPhysicalRootPath()+ "/Frame/page/resources/fonts/";
		//Html2Pdf.READER_PWD = "";
		Html2Pdf.generatePdf(sHtmlFileName, sPdfFileName, config.getWebRootPath());
		return sPdfFileName;
	}
	
	/**
	 * 生成一笔格式化报告
	 * @param config 格式化报告参数配置对象
	 * @param asUser:当前用户
	 * @param sObjectType:对象类型
	 * @param sObjectNo:业务流水号
	 * @param sDocID:调查报告文档类别
	 * 
	 * @return true/false: 成功或失败
	 * 
	 * @throws JBOException 
	 */
	public String genDocument(FormatDocConfig config,String sBasePath,ASUser asUser,String sObjectType,String sObjectNo,String sDocID) throws JBOException
	{		
		try {
			//ServletContext sc = request.getSession().getServletContext();
			
			String sToday = DateX.format(new java.util.Date());
			
			JBOFactory factory = JBOFactory.getFactory();

			BizObjectManager bmRecord = null;
			BizObject boRecord = null;
			BizObjectQuery bqRecord = null;
			
			BizObjectManager bmData = null;
			BizObject boData = null;
			BizObjectQuery bqData = null;
			
			bmRecord = factory.getManager("jbo.app.FORMATDOC_RECORD");
			bqRecord = bmRecord.createQuery("select SerialNo from O where ObjectType = :objecttype and ObjectNo = :objectno and DocID = :docid ").
					setParameter("objecttype",sObjectType).
					setParameter("objectno",sObjectNo).
					setParameter("docid",sDocID);
			boRecord = bqRecord.getSingleResult(false);
			if(boRecord==null){//首次生成格式化报告
				newDocument(asUser,sObjectType,sObjectNo,sDocID);
				boRecord = bqRecord.getSingleResult(false);
			}
			String sRecordSerialNo = boRecord.getAttribute("SerialNo").getString();
			String sBaseFileName = com.amarsoft.are.security.MessageDigest.getDigestAsLowerHexString("MD5", sRecordSerialNo);
	    	java.io.File dFile=null;
	        //判断路径是否存在，如果不存在自动创建;文档存储路径中增加以当年年份命名的目录 cdeng 2009-02-12
	    	String sFileSavePath = sBasePath+"/"+sToday.substring(0,4)+"/"+sToday.substring(5,7)+"/"+sObjectType;
    		dFile=new java.io.File(sFileSavePath);
    		if(!dFile.exists()) {
    			try {
	    			if(dFile.mkdirs()){
	    				ARE.getLog().info("文档存储路径["+sFileSavePath+"]创建成功！");
	    			}else{
	    				ARE.getLog().trace("文档存储路径["+sFileSavePath+"]创建失败！");
	    				throw new IOException("文档存储路径["+sFileSavePath+"]创建失败！");
	    			}
    			}catch (SecurityException e) {
    				ARE.getLog().error(e.getMessage(),e);
    				throw new SecurityException("请检查文件路径["+sBasePath+"]读写权限！");
	    		}
	    	}
	    	String sFileName = sFileSavePath+"/"+sBaseFileName+".html";

	        java.io.File file = new java.io.File(sFileName);
	        java.io.FileOutputStream fileOut = null;
	        fileOut = new java.io.FileOutputStream(file,false);
	        fileOut.write("<div id=als7fdall>".getBytes(ARE.getProperty("CharSet","GBK")));
	        
			bmData = factory.getManager("jbo.app.FORMATDOC_DATA");
			bqData = bmData.createQuery("select SerialNo from O where RelativeSerialNo=:relativeserialno order by TreeNo ").
						setParameter("relativeserialno", sRecordSerialNo);
			List lboData = bqData.getResultList(false);
			for(int i=0;i<lboData.size();i++){
				boData = (BizObject)lboData.get(i);
				String sSerialNo = boData.getAttribute("SerialNo").getString();
				FormatDocData oData = (FormatDocData)FormatDocHelp.getFDDataObject(sSerialNo,"com.amarsoft",config);
				//oData.forceRefreshObject();
				String sTemp = oData.getHtml(IFormatDocData.FDDATA_EXPORT,ARE.getProperty("CharSet","GBK"));
				sTemp = "<a name=\"node_"+ i +"\"/><div>"+ sTemp +"</div>";
		        fileOut.write(("<table align=\"center\" style=\"width:660px;table-layout:fixed;\" background='"+config.getHttpRootPath() + oData.getWatermark() +"'><tr><td style=\"white-space:nowrap;overflow:hidden;\">" + sTemp + "</td></tr></table>").getBytes(ARE.getProperty("CharSet","GBK")));
			}
			
			fileOut.write("</div>".getBytes(ARE.getProperty("CharSet","GBK")));
			fileOut.close();
			
			bqRecord = bmRecord.createQuery("Update O set SAVEPATH=:SAVEPATH,SAVEDATE=:SAVEDATE,USERID=:USERID,ORGID=:ORGID,UPDATEDATE=:UPDATEDATE where SERIALNO = :SERIALNO ").
						setParameter("SAVEPATH",sFileName).
						setParameter("SAVEDATE",sToday).
						setParameter("USERID",asUser.getUserID()).
						setParameter("ORGID",asUser.getOrgID()).
						setParameter("UPDATEDATE",sToday).
						setParameter("SERIALNO",sRecordSerialNo);
			bqRecord.executeUpdate();
			
			return sFileName;

		} catch (Exception e) {
			e.printStackTrace();
			return "";
		}
	}
	
	/**
	 * 导出一笔离线格式化报告
	 * 
	 * @param asUser:当前用户
	 * @param sObjectType:对象类型
	 * @param sObjectNo:业务流水号
	 * @param sDocID:调查报告文档类别
	 * @return true/false: 成功或失败
	 * @throws JBOException 
	 */
	public String exportOfflineDocument(FormatDocConfig config,String sBasePath,ASUser asUser,String sObjectType,String sObjectNo,String sDocID) throws JBOException
	{		
		try {
			//ServletContext sc = request.getSession().getServletContext();
			
			String sToday = DateX.format(new java.util.Date());
			
			JBOFactory factory = JBOFactory.getFactory();

			BizObjectManager bmRecord = null;
			BizObject boRecord = null;
			BizObjectQuery bqRecord = null;
			
			BizObjectManager bmData = null;
			BizObject boData = null;
			BizObjectQuery bqData = null;
			
			bmRecord = factory.getManager("jbo.app.FORMATDOC_RECORD");
			bqRecord = bmRecord.createQuery("select SerialNo from O where ObjectType = :objecttype and ObjectNo = :objectno and DocID = :docid ").
					setParameter("objecttype",sObjectType).
					setParameter("objectno",sObjectNo).
					setParameter("docid",sDocID);
			boRecord = bqRecord.getSingleResult(false);
			if(boRecord==null){//首次生成格式化报告
				newDocument(asUser,sObjectType,sObjectNo,sDocID);
				boRecord = bqRecord.getSingleResult(false);
			}
			String sRecordSerialNo = boRecord.getAttribute("SerialNo").getString();
			String sBaseFileName = com.amarsoft.are.security.MessageDigest.getDigestAsLowerHexString("MD5", sRecordSerialNo);
	    	java.io.File dFile=null;
	        //判断路径是否存在，如果不存在自动创建;文档存储路径中增加以当年年份命名的目录 cdeng 2009-02-12
	    	String sFileSavePath = sBasePath+"/"+sToday.substring(0,4)+"/"+sToday.substring(5,7)+"/"+sObjectType;
    		dFile=new java.io.File(sFileSavePath);
    		if(!dFile.exists()) {
    			try {
	    			if(dFile.mkdirs()){
	    				ARE.getLog().info("文档存储路径["+sFileSavePath+"]创建成功！");
	    			}else{
	    				ARE.getLog().trace("文档存储路径["+sFileSavePath+"]创建失败！");
	    				throw new IOException("文档存储路径["+sFileSavePath+"]创建失败！");
	    			}
    			}catch (SecurityException e) {
    				ARE.getLog().error(e.getMessage(),e);
    				throw new SecurityException("请检查文件路径["+sBasePath+"]读写权限！");
	    		}
	    	}
	    	String sFileName = sFileSavePath+"/"+sBaseFileName+".amardoc";

	        java.io.File file = new java.io.File(sFileName);
	        java.io.FileOutputStream fileOut = null;
	        fileOut = new java.io.FileOutputStream(file,false);
	        bmData = factory.getManager("jbo.app.FORMATDOC_DATA");
			bqData = bmData.createQuery("select SerialNo,DIRNAME from O where RelativeSerialNo=:relativeserialno order by TreeNo ").
						setParameter("relativeserialno", sRecordSerialNo);
			List lboData = bqData.getResultList(false);
		
			int iOfflineVersion = getOfflineVersion(bmRecord,sRecordSerialNo);
			//新增FORMATDOC_OFFLINE记录
			
			BizObjectManager bmFO = JBOFactory.getFactory().getManager("jbo.app.FORMATDOC_OFFLINE");
			//String sOfflineSerialNo = DBKeyHelp.getSerialNo("FORMATDOC_OFFLINE","SERIALNO",new Transaction(bmFO.getDatabase()));
			BizObject boFO = bmFO.newObject();
			//boFO.setAttributeValue("SERIALNO", sOfflineSerialNo);
			boFO.setAttributeValue("OBJECTTYPE", sObjectType);
			boFO.setAttributeValue("OBJECTNO", sObjectNo);
			boFO.setAttributeValue("DOCID", sDocID);
			boFO.setAttributeValue("SAVEPATH", sFileName);
			boFO.setAttributeValue("ORGID", asUser.getOrgID());
			boFO.setAttributeValue("USERID", asUser.getUserID());
			boFO.setAttributeValue("INPUTDATE", sToday);
			boFO.setAttributeValue("DIRECTION", "down");
			bmFO.saveObject(boFO);
			if(lboData==null) {
				fileOut.close();
				throw new JBOException("没有任何数据可导出:DocID+" + sDocID + ",ObjectType=" + sObjectType + ",ObjectNO=" + sObjectNo);
			}
			//多出的三个是：主页面main.htm,左侧才单页menu.htm,右侧内容页content.htm
			StringBuffer[] sbBodyArray = new StringBuffer[lboData.size()+3];
			String[] pageNames = new String[lboData.size()+3];
			//建立主页面
			sbBodyArray[0]= new MainHtmlGenerator(iOfflineVersion,sDocID,sObjectType,sObjectNo).getHtml();
			pageNames[0]="main.html";
			//生成菜单页
			sbBodyArray[1]= new MenuHtmlGenerator(lboData,config).getHtml();
			pageNames[1]="menu.html";
			//生成空页面:right.htm
			sbBodyArray[2] = new RightHtmlGenerator(iOfflineVersion,sDocID,sObjectType,sObjectNo,config).getHtml();// new StringBuffer();
			pageNames[2]="content.html";
			//循环生成内容页，内容页生成之后再生成菜单
			ArrayList imgFiles = new ArrayList();//图片地址
			for(int i=0;i<lboData.size();i++){
				boData = (BizObject)lboData.get(i);
				sbBodyArray[i+3]=  new ContentHtmlGenerator(boData,imgFiles,config).getHtml();
				pageNames[i+3]="content_"+ boData.getAttribute("SERIALNO").getString() +".html";
			}
			byte[] bsResult = new AmarDocParser().zip(sbBodyArray,imgFiles,pageNames);
			fileOut.write(bsResult);
			fileOut.close();
			return sFileName;

		} catch (Exception e) {
			e.printStackTrace();
			return "";
		}
	}
	
	private int getOfflineVersion(BizObjectManager manager,String sRecordSerialNo)throws Exception{
		JBOTransaction tx = null;
		int result = 0;
		try {
			tx = JBOFactory.getFactory().createTransaction();
			tx.join(manager);
			BizObjectQuery querey = manager.createQuery("Update O set OFFLINEVERSION=OFFLINEVERSION+1 where SERIALNO = :SERIALNO ").
				setParameter("SERIALNO",sRecordSerialNo);
			querey.executeUpdate();
			querey = manager.createQuery("select OFFLINEVERSION from O where SERIALNO = :SERIALNO").setParameter("SERIALNO",sRecordSerialNo);
			result = querey.getSingleResult(false).getAttribute("OFFLINEVERSION").getInt();
			tx.commit();
			return result;
		} catch (Exception e) {
			if(tx!=null) tx.rollback();
			return result;
		}
	}
	
	/**
	 * 获得格式化报告的路径
	 * @param asUser:当前用户
	 * @param sObjectType:对象类型
	 * @param sObjectNo:业务流水号
	 * @param sDocID:调查报告文档类别
	 * @return true/false: 成功或失败
	 * @throws JBOException 
	 */
	public String getFullFileName(String sObjectType,String sObjectNo,String sDocID) throws JBOException {
		try {
			BizObjectManager bmRecord = JBOFactory.getFactory().getManager("jbo.app.FORMATDOC_RECORD");
			BizObjectQuery bqRecord = bmRecord.createQuery("select SavePath from O where ObjectType = :objecttype and ObjectNo = :objectno and DocID = :docid ").
					setParameter("objecttype",sObjectType).setParameter("objectno",sObjectNo).setParameter("docid",sDocID);
			BizObject boRecord = bqRecord.getSingleResult(false);
			String sSavePath = boRecord.getAttribute("SavePath").getString();
			return sSavePath;
		} catch (Exception e) {
			e.printStackTrace();
			return "";
		}
	}
	
	public String getOfflineFilePath(String sObjectType,String sObjectNo,String sDocID) throws JBOException{
		try {
			BizObjectManager bmRecord = JBOFactory.getFactory().getManager("jbo.app.FORMATDOC_OFFLINE");
			BizObjectQuery bqRecord = bmRecord.createQuery("select SavePath from O where ObjectType = :objecttype and ObjectNo = :objectno and DocID = :docid and direction='down'").
					setParameter("objecttype",sObjectType).
					setParameter("objectno",sObjectNo).
					setParameter("docid",sDocID);
			BizObject boRecord = bqRecord.getSingleResult(false);
			String sSavePath = "";
			if(boRecord!=null && !boRecord.getAttribute("SavePath").isNull()){
				sSavePath = boRecord.getAttribute("SavePath").getString();
				return sSavePath.substring(0,sSavePath.lastIndexOf("/"));
			}else 
				return "";
		} catch (Exception e) {
			e.printStackTrace();
			return "";
		}
	}
	 
	protected void updateNeedFlag(ASUser asUser,String sObjectType,String sObjectNo,String sDocID){
		try {
			String sDirID = "";
			String sTreeNo = null;
			String sDirName = null;
			String sOrgID = FormatDocHelp.getBranchOrgID(asUser.getOrgID());
			JBOFactory factory = JBOFactory.getFactory();
			//if(tx == null) tx = factory.getTransaction();
			String sTemp = "";
			
			BizObjectManager bmPara = factory.getManager("jbo.app.FORMATDOC_PARA");
			//tx.join(bmPara);
			BizObjectQuery bqPara = bmPara.createQuery("SELECT DefaultValue FROM O WHERE OrgID = :OrgID and DocID = :DocID");
			BizObject boPara = bqPara.setParameter("OrgID", sOrgID).setParameter("DocID", sDocID).getSingleResult(false);
			if(boPara !=null) sTemp = boPara.getAttribute("DefaultValue").getString();
			if(sTemp == null || sTemp.length() == 0) sTemp = "";
			
			StringTokenizer st = new StringTokenizer(sTemp,",");
			while(st.hasMoreTokens()){	
				sDirID += "'"+st.nextToken()+"',";
			}
			//增加判断，避免数组越界
			if(sDirID.length()>0){
				sDirID = sDirID.substring(0,sDirID.length()-1);

				BizObjectManager bmData = factory.getManager("jbo.app.FORMATDOC_DATA");
				//tx.join(bmData);
				String sQuery = " select O.TreeNo,O.DirName from O,jbo.app.FORMATDOC_DEF FF " +
				" where O.DirID = FF.DirID and FF.DocID = :DocID and FF.DirID IN ("+sDirID+") and FF.Attribute1 = '1' and O.ObjectNo = :ObjectNo ";
				BizObjectQuery bqData = bmPara.createQuery(sQuery).setParameter("DocID", sDocID).setParameter("ObjectNo", sObjectNo);
				List<BizObject> listData = bqData.getResultList(false);
				for(BizObject bo:listData){
					sTreeNo = bo.getAttribute("TreeNo").getString();
					sDirName = bo.getAttribute("DirName").getString();
					if(!sDirName.substring(sDirName.length()-4,sDirName.length()).equals("(自动)")&&!sDirName.substring(sDirName.length()-4,sDirName.length()).equals("(必填)")){
						bqData = bmData.createQuery("Update O Set DirName = :DirName where DocID = :DocID and TreeNo = :TreeNo and ObjectNo = :ObjectNo");
						bqData.setParameter("DirName", sDirName+"(必填)").setParameter("DocID", sDocID).setParameter("TreeNo", sTreeNo).setParameter("ObjectNo", sObjectNo);
						bqData.executeUpdate();
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
