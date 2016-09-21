package com.amarsoft.app.als.formatdoc;

import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.als.guaranty.model.GuarantyConst;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.DBKeyHelp;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.formatdoc.model.DefaultFormatTool;
import com.amarsoft.context.ASUser;
import com.amarsoft.dict.als.manage.NameManager;
/**
 * @des 生成报告工具类als7实现类
 * 已实现插入、更新担保人信息
 * @author flian
 * @history 2011-10-11
 *
 */
public class ALS7FormatToolNew extends DefaultFormatTool{
	/**
	 * 新增一笔格式化报告(适用于授信业务流程中的相关报告，如公司授信贷前调查报告)
	 * 
	 * @param asUser:当前用户
	 * @param sObjectType:对象类型
	 * @param sObjectNo:业务流水号
	 * @param sDocID:调查报告文档类别
	 * 
	 * @return true/false: 成功或失败
	 * 
	 * @throws JBOException 
	 */
	public boolean newDocument(ASUser asUser,String sObjectType,String sObjectNo,String sDocID) throws JBOException
	{
		//JBOTransaction tx = JBOFactory.getFactory().getTransaction();
		String today = StringFunction.getToday();
		java.text.DecimalFormat formatter2 = new java.text.DecimalFormat("00");
		JBOTransaction tx = JBOFactory.getFactory().createJBOTransaction();
		try {
			JBOFactory factory = JBOFactory.getFactory();

			BizObjectManager bmRecord = null;
			BizObject boRecord = null;
			
			BizObjectManager bmData = factory.getManager("jbo.app.FORMATDOC_DATA");
			tx.join(bmData);
			BizObject boData = null;
			
			BizObjectManager bmDef = null;
			BizObjectQuery bqDef = null;
			BizObject boDef = null;
			bmRecord = factory.getManager("jbo.app.FORMATDOC_RECORD");
			tx.join(bmRecord);

			String sSerialNo = DBKeyHelp.getSerialNo("FORMATDOC_RECORD","SERIALNO",new Transaction(bmRecord.getDatabase()));
			
			boRecord = bmRecord.newObject();
			boRecord.setAttributeValue("SERIALNO", sSerialNo);
			boRecord.setAttributeValue("OBJECTTYPE", sObjectType);
			boRecord.setAttributeValue("OBJECTNO", sObjectNo);
			boRecord.setAttributeValue("DOCID", sDocID);
			boRecord.setAttributeValue("ORGID", asUser.getOrgID());
			boRecord.setAttributeValue("USERID", asUser.getUserID());
			boRecord.setAttributeValue("INPUTDATE", today);
			boRecord.setAttributeValue("UPDATEDATE", today);
			boRecord.setAttributeValue("OFFLINEVERSION", 0);
			bmRecord.saveObject(boRecord);
			
			bmDef = factory.getManager("jbo.app.FORMATDOC_DEF");
			bqDef = bmDef.createQuery("select DOCID,DIRID,DIRNAME,JSPFILENAME,HTMLFILENAME,ARRANGEATTR,CIRCLEATTR,ATTRIBUTE1 from O where DOCID=:docid").
						setParameter("docid", sDocID);
			List lboDef = bqDef.getResultList();
			for(int i=0;i<lboDef.size();i++){
				boDef = (BizObject)lboDef.get(i);
				//如果在排除字段中则跳过
				if(this.isExclude(boDef.getAttribute("DIRID").getString()))
					continue;
				if(boDef.getAttribute("CIRCLEATTR").getValue()!=null && !boDef.getAttribute("CIRCLEATTR").getString().equals("0") && boDef.getAttribute("CIRCLEATTR").getString().trim().length()>0)
					continue;
				boData = bmData.newObject();
				boData.setAttributeValue("RELATIVESERIALNO",sSerialNo);
				boData.setAttributeValue("TREENO",boDef.getAttribute("DIRID").getString());
				boData.setAttributeValue("DOCID",sDocID);
				boData.setAttributeValue("DIRID",boDef.getAttribute("DIRID").getString());
				boData.setAttributeValue("DIRNAME",boDef.getAttribute("DIRNAME").getString());
				//TODO GUARANTYNO?? CUSTOMERID??
				boData.setAttributeValue("CONTENTLENGTH",0);
				boData.setAttributeValue("ORGID",asUser.getOrgID());
				boData.setAttributeValue("USERID",asUser.getUserID());
				boData.setAttributeValue("INPUTDATE", today);
				boData.setAttributeValue("UPDATEDATE", today);
				bmData.saveObject(boData);
			}
			
			//TODO 分情况讨论担保情况
			//判断是否有相关担保信息：circleattr='1'
			//再插入个人保证人信息：circleattr='09'
			String query = "select O.guarantyid,o.COLASSETOWNER from O where O.certtype like 'Ind%' and  O.GuarantyID in (select"
					+ " GR.GuarantyID from "+GuarantyConst.GUARANTY_RELATIVE+" GR where GR.RelationStatus = '010' and GR.GCContractNo in (select gc.SerialNo"
					+ " from "+GuarantyConst.GUARANTY_CONTRACT+" gc where gc.GUARANTYTYPE='010010' and gc.SerialNo in (select acs.GUR_SERIALNO from" 
					+ " jbo.app.AGR_CRE_SEC_RELA acs where acs.SerialNo=:ObjectNo and" 
					+ " acs.CREDITOBJTYPE='CreditApply')))";
//					+ " and O.guarantyid in (select gfr.col_serialno from jbo.app.GUAR_FAC_RELA gfr where gfr.reffacobjid=:ObjectNo1 and gfr.reffacobjtype='CreditApply')";
			//这里只取o.COLASSETOWNER值
			//insertGuaranty(asUser,sObjectType,sObjectNo,sDocID,JBOFactory.getFactory().getManager("jbo.app.GUARANTY_INFO"),query,"guarantyid","COLASSETOWNER","09",sSerialNo,today,tx);
			//再插入公司保证人信息：circleattr='10'
			query = "select O.guarantyid,o.COLASSETOWNER from O where O.certtype like 'Ent%' and  O.GuarantyID in (select"
					+ " GR.GuarantyID from "+GuarantyConst.GUARANTY_RELATIVE+" GR where GR.RelationStatus = '010' and GR.GCContractNo in (select gc.SerialNo"
					+ " from  "+GuarantyConst.GUARANTY_CONTRACT+"  gc where gc.GUARANTYTYPE='010010' and gc.SerialNo in (select acs.GUR_SERIALNO from" 
					+ " jbo.app.AGR_CRE_SEC_RELA acs where acs.SerialNo=:ObjectNo and" 
					+ " acs.CREDITOBJTYPE='CreditApply')))";
//					+ " and O.guarantyid in (select gfr.col_serialno from jbo.app.GUAR_FAC_RELA gfr where gfr.reffacobjid=:ObjectNo1 and gfr.reffacobjtype='CreditApply')";
			//这里只取o.COLASSETOWNER值
			//insertGuaranty(asUser,sObjectType,sObjectNo,sDocID,JBOFactory.getFactory().getManager("jbo.app.GUARANTY_INFO"),query,"guarantyid","COLASSETOWNER","10",sSerialNo,today,tx);
			//再插入保证人信息：circleattr='11',合并09和10,当个人和公司只不一起出现时可以替换09和10
			query = "select O.guarantyid,o.COLASSETOWNER from O where O.GuarantyID in (select"
					+ " GR.GuarantyID from "+GuarantyConst.GUARANTY_RELATIVE+" GR where GR.RelationStatus = '010' and GR.GCContractNo in (select gc.SerialNo"
					+ " from  "+GuarantyConst.GUARANTY_CONTRACT+"  gc where gc.GUARANTYTYPE='010010' and gc.SerialNo in (select acs.GUR_SERIALNO from" 
					+ " jbo.app.AGR_CRE_SEC_RELA acs where acs.SerialNo=:ObjectNo and" 
					+ " acs.CREDITOBJTYPE='CreditApply')))";
//					+ " and O.guarantyid in (select gfr.col_serialno from jbo.app.GUAR_FAC_RELA gfr where gfr.reffacobjid=:ObjectNo1 and gfr.reffacobjtype='CreditApply')";
			//这里只取o.COLASSETOWNER值
			//insertGuaranty(asUser,sObjectType,sObjectNo,sDocID,JBOFactory.getFactory().getManager("jbo.app.GUARANTY_INFO"),query,"guarantyid","COLASSETOWNER","11",sSerialNo,today,tx);
			
			/*
			//再插入履约保险保证信息：circleattr='111'
			query = " select SerialNo,GuarantorName from O " +
			" where SerialNo in (select objectno  from jbo.app.APPLY_RELATIVE "+
			" where ObjectType = 'GuarantyContract' and SerialNo =:ObjectNo)  and GuarantyType = '010020'";
			insertGuaranty(asUser,sObjectType,sObjectNo,sDocID,factory.getManager(""+GuarantyConst.GUARANTY_CONTRACT+" "),query,"111",sSerialNo,today,tx);
			//再插入保函保证信息：circleattr='1111':【程序待验证-flian 201109027】
			query = " select SerialNo,GuarantorName from O " +
				" where SerialNo in (select objectno  from jbo.app.APPLY_RELATIVE "+
				" where ObjectType = 'GuarantyContract' and SerialNo =:ObjectNo)  and GuarantyType = '010030'";
			insertGuaranty(asUser,sObjectType,sObjectNo,sDocID,factory.getManager(""+GuarantyConst.GUARANTY_CONTRACT+" "),query,"1111",sSerialNo,today,tx);
			//再插入保证金保证信息：circleattr='111111':【程序待验证-flian 201109027】
			query = " select SerialNo,GuarantorName from O " +
				" where SerialNo in (select objectno  from jbo.app.APPLY_RELATIVE "+
				" where ObjectType = 'GuarantyContract' and SerialNo =:ObjectNo)  and GuarantyType = '010040'";
			insertGuaranty(asUser,sObjectType,sObjectNo,sDocID,factory.getManager(""+GuarantyConst.GUARANTY_CONTRACT+" "),query,"111111",sSerialNo,today,tx);
			//再插入抵押信息：circleattr='12' 
			query = "o.GuarantyType like '010%'";
			insertGuaranty2(asUser,sObjectType,sObjectNo,sDocID,query,"12",sSerialNo,today,tx);
			//再插入质押信息：circleattr='13'
			query = "o.GuarantyType like '020%'";
			insertGuaranty2(asUser,sObjectType,sObjectNo,sDocID,query,"13",sSerialNo,today,tx);
			*/
			
						
			//TODO 根据FORMATDOC_PARA,FORMATDOC_DEF中的Attribute1 设置 (必填)
			updateNeedFlag(asUser,sObjectType,sObjectNo,sDocID);
			tx.commit();
			
		} catch (Exception e) {
			tx.rollback();
			e.printStackTrace();
			return false;
		}
		return true;
		
	}
	
	private void insertGuaranty(ASUser asUser,String sObjectType,String sObjectNo,String sDocID,BizObjectManager manager,String query,String displayNo,String displayTitle,String circleattr,String sSerialNo,String today,JBOTransaction tx)throws Exception{
		java.text.DecimalFormat formatter2 = new java.text.DecimalFormat("00000000000000000000");
		//再插入个人保证人信息：circleattr='11'
		String[][] attr11DataArray = new String[0][2];
		List attr11List = manager.createQuery(query)
			.setParameter("ObjectType", sObjectType)
			.setParameter("ObjectNo", sObjectNo)
//			.setParameter("ObjectNo1", sObjectNo)
			.getResultList();
		if(attr11List!=null){
			attr11DataArray = new String[attr11List.size()][2];
			for(int i=0;i<attr11List.size();i++){
				BizObject obj = (BizObject)attr11List.get(i);
				attr11DataArray[i][0] = obj.getAttribute(displayNo).getString();
				attr11DataArray[i][1] = obj.getAttribute(displayTitle).getString();
			}
		}
		BizObjectManager bmData = JBOFactory.getFactory().getManager("jbo.app.FORMATDOC_DATA");
		tx.join(bmData);
		BizObjectManager bmDef = JBOFactory.getFactory().getManager("jbo.app.FORMATDOC_DEF");
		BizObjectQuery bqDef = bmDef.createQuery("select DOCID,DIRID,DIRNAME,JSPFILENAME,HTMLFILENAME,ARRANGEATTR,CIRCLEATTR,ATTRIBUTE1 from O where DOCID=:docid and CIRCLEATTR=:CIRCLEATTR order by DIRID").
			setParameter("docid", sDocID).setParameter("CIRCLEATTR", circleattr);
		List attr11DefList = bqDef.getResultList();
		String sFirstDirID = "";
		for(int i=0;i<attr11DefList.size();i++){
			BizObject obj = (BizObject)attr11DefList.get(i);
			if(i==0)sFirstDirID = obj.getAttribute("DIRID").getString();//获得首个节点编号,如0601，目的为做递增替换
			for(int j=0;j<attr11DataArray.length;j++){
				BizObject boData = bmData.newObject();
				boData.setAttributeValue("GUARANTYNO",attr11DataArray[j][0]);
				boData.setAttributeValue("RELATIVESERIALNO",sSerialNo);
				int iTreeNo = Integer.parseInt(sFirstDirID) + j;
				String sTreeNo =obj.getAttribute("DIRID").getString();
				sTreeNo = formatter2.format(iTreeNo).substring(20-sFirstDirID.length()) + sTreeNo.substring(sFirstDirID.length());
				
				boData.setAttributeValue("TREENO",sTreeNo);
				
				boData.setAttributeValue("DOCID",sDocID);
				boData.setAttributeValue("DIRID",obj.getAttribute("DIRID").getString());
				String sDirName = obj.getAttribute("DIRNAME").getString();
				if(i==0)
					sDirName+= " - " + NameManager.getCustomerName(attr11DataArray[j][1]);
				boData.setAttributeValue("DIRNAME",sDirName);
				
				boData.setAttributeValue("CONTENTLENGTH",0);
				boData.setAttributeValue("ORGID",asUser.getOrgID());
				boData.setAttributeValue("USERID",asUser.getUserID());
				boData.setAttributeValue("INPUTDATE", today);
				boData.setAttributeValue("UPDATEDATE", today);
				bmData.saveObject(boData);
			}
		}
	}
	
	private void updateGuaranty(ASUser asUser,String sObjectType,String sObjectNo,String sDocID,BizObjectManager manager,String query,String displayNo,String displayTitle,String circleattr,String today,JBOTransaction tx)throws Exception{
		String sSerialNo = "";//获得formatdoc_record.serialno
		BizObjectManager bmRecord = JBOFactory.getFactory().getManager("jbo.app.FORMATDOC_RECORD");
		BizObject objX = bmRecord.createQuery("DOCID=:DOCID and ObjectType=:ObjectType and ObjectNo=:ObjectNo")
			.setParameter("DOCID", sDocID)
			.setParameter("ObjectType", sObjectType)
			.setParameter("ObjectNo", sObjectNo)
			.getSingleResult();
		if(objX==null){
			throw new Exception("FORMATDOC_RECORD中找不到合适的记录");
		}
		sSerialNo = objX.getAttribute("SERIALNO").getString();
		
		java.text.DecimalFormat formatter2 = new java.text.DecimalFormat("00000000000000000000");
		String[][] attr11DataArray = new String[0][2];//保存所有业务担保信息列表，格式为String[]{"编号","标题"}
		//attr11List:获得所有业务担保信息列表
		List attr11List = manager.createQuery(query)
			.setParameter("ObjectType", sObjectType)
			.setParameter("ObjectNo", sObjectNo)
//			.setParameter("ObjectNo1", sObjectNo)
			.getResultList();
		String sNotdeletGNos = "";
		if(attr11List!=null){
			attr11DataArray = new String[attr11List.size()][2];
			for(int i=0;i<attr11List.size();i++){
				BizObject obj = (BizObject)attr11List.get(i);
				attr11DataArray[i][0] = obj.getAttribute(displayNo).getString();
				attr11DataArray[i][1] = obj.getAttribute(displayTitle).getString();
				if(sNotdeletGNos.equals(""))
					sNotdeletGNos="'" + attr11DataArray[i][0] + "'";
				else
					sNotdeletGNos+=",'" + attr11DataArray[i][0] + "'";
			}
		}
		BizObjectManager bmData = JBOFactory.getFactory().getManager("jbo.app.FORMATDOC_DATA");
		tx.join(bmData);
		//删除多余的担保信
		String delsql = "";
		if(sNotdeletGNos.equals("")){
			delsql = "delete from O where docid=:docid and relativeserialno=:relativeserialno"
				+ " and dirid in(select dirid from jbo.app.FORMATDOC_DEF d where d.docid=o.docid and d.CIRCLEATTR='"+circleattr+"')"
				+" and GUARANTYNO is not null";
		}
		else{
			delsql = "delete from O where docid=:docid and relativeserialno=:relativeserialno"
			+ " and dirid in(select dirid from jbo.app.FORMATDOC_DEF d where d.docid=o.docid and d.CIRCLEATTR='"+circleattr+"')"
			+" and GUARANTYNO is not null and GUARANTYNO not in("+sNotdeletGNos+")";
		}
		bmData.createQuery(delsql)
			.setParameter("relativeserialno", sSerialNo)
			.setParameter("docid", sDocID)
			.setParameter("CIRCLEATTR", circleattr)
			.executeUpdate();
		
		//查找新增出来的担保信息，进行新增
		ArrayList<String> newgurantynolist = new ArrayList<String>(); 
		List listall = bmData.createQuery("relativeserialno=:relativeserialno and docid=:docid "
			+"and GUARANTYNO is not null "
			+ "and dirid in(select dirid from jbo.app.FORMATDOC_DEF d where d.docid=o.docid and d.CIRCLEATTR='"+circleattr+"')")
			.setParameter("relativeserialno", sSerialNo)
			.setParameter("docid", sDocID)
			.setParameter("CIRCLEATTR", circleattr)
			.getResultList();
		if(listall!=null){
			for(int ii=0;ii<listall.size();ii++){
				BizObject obj = (BizObject)listall.get(ii);
				if(!newgurantynolist.contains(obj.getAttribute("GUARANTYNO").getString())){
					newgurantynolist.add(obj.getAttribute("GUARANTYNO").getString());
				}
			}
		}
		//获得真正要新增的担保编号
		ArrayList<String[]> toInsertGuarantyNoList = new ArrayList<String[]>(); 
		for(int jj=0;jj<attr11DataArray.length;jj++){
			if(!newgurantynolist.contains(attr11DataArray[jj][0])){
				toInsertGuarantyNoList.add(attr11DataArray[jj]);
			}
		}
		//开始真正插入数据
		BizObjectManager bmDef = JBOFactory.getFactory().getManager("jbo.app.FORMATDOC_DEF");
		BizObjectQuery bqDef = bmDef.createQuery("select DOCID,DIRID,DIRNAME,JSPFILENAME,HTMLFILENAME,ARRANGEATTR,CIRCLEATTR,ATTRIBUTE1 from O where DOCID=:docid and CIRCLEATTR=:CIRCLEATTR order by DIRID").
			setParameter("docid", sDocID).setParameter("CIRCLEATTR", circleattr);
		String sMaxTreeNo = "";
		List attr11DefList = bqDef.getResultList();//获得模型数据
		String sFirstDirID="";
		for(int i=0;i<attr11DefList.size();i++){//循环模型数据
			BizObject obj = (BizObject)attr11DefList.get(i);
			if(sFirstDirID.equals("")){
				sFirstDirID = obj.getAttribute("DIRID").getString();//获得首个节点编号,如0601，目的为做递增替换
				
				BizObjectQuery bqDefMax = bmData.createQuery("select treeno from O where relativeserialno=:relativeserialno and dirid=:dirid order by treeno desc").
					setParameter("relativeserialno", sSerialNo).setParameter("dirid", sFirstDirID);
				BizObject objmx = bqDefMax.getSingleResult();
				if(objmx!=null){
					sMaxTreeNo = objmx.getAttribute("treeno").getString();
				}
				else{
					sMaxTreeNo = sFirstDirID;
				}
			}
			int kk=0;
			for(int j=0;j<toInsertGuarantyNoList.size();j++){
				kk++;
				BizObject boData = bmData.newObject();
				boData.setAttributeValue("GUARANTYNO",toInsertGuarantyNoList.get(j)[0]);
				boData.setAttributeValue("RELATIVESERIALNO",sSerialNo);
				
				int iTreeNo = Integer.parseInt(sMaxTreeNo) + kk;
				String sTreeNo =obj.getAttribute("DIRID").getString();
				sTreeNo = formatter2.format(iTreeNo).substring(20-sFirstDirID.length()) + sTreeNo.substring(sFirstDirID.length());
				boData.setAttributeValue("TREENO",sTreeNo);
				
				boData.setAttributeValue("DOCID",sDocID);
				boData.setAttributeValue("DIRID",obj.getAttribute("DIRID").getString());
				
				String sDirName = obj.getAttribute("DIRNAME").getString();
				if(i==0)
					sDirName+= " - " + NameManager.getCustomerName(toInsertGuarantyNoList.get(j)[1]);
				boData.setAttributeValue("DIRNAME",sDirName);
				
				boData.setAttributeValue("CONTENTLENGTH",0);
				boData.setAttributeValue("ORGID",asUser.getOrgID());
				boData.setAttributeValue("USERID",asUser.getUserID());
				boData.setAttributeValue("INPUTDATE", today);
				boData.setAttributeValue("UPDATEDATE", today);
				bmData.saveObject(boData);
			}
		}
		
	}
	/**
	 * 刷新一笔格式化报告的目录(适用于授信业务流程中的相关报告，如公司授信贷前调查报告)
	 * 
	 * @param asUser:当前用户
	 * @param sObjectType:对象类型
	 * @param sObjectNo:业务流水号
	 * @param sDocID:调查报告文档类别
	 * 
	 * @return true/false: 成功或失败
	 * 
	 * @throws JBOException 
	 */
	public boolean refreshDocument(ASUser asUser,String sObjectType,String sObjectNo,String sDocID ){
		String today = StringFunction.getToday();
		JBOTransaction tx = null;
		try{
			tx=JBOFactory.getFactory().createJBOTransaction();
			//TODO 根据担保情况变动，刷新格式化报告
			//判断是否有相关担保信息：circleattr='1'
			//再插入个人保证人信息：circleattr='09'
			String query = "select O.guarantyid,o.COLASSETOWNER from O where O.certtype like 'Ind%' and  O.GuarantyID in (select"
					+ " GR.GuarantyID from "+GuarantyConst.GUARANTY_RELATIVE+" GR where GR.RelationStatus = '010' and GR.GCContractNo in (select gc.SerialNo"
					+ " from "+GuarantyConst.GUARANTY_CONTRACT+"  gc where gc.GUARANTYTYPE='010010' and gc.SerialNo in (select acs.GUR_SERIALNO from" 
					+ " jbo.app.AGR_CRE_SEC_RELA acs where acs.SerialNo=:ObjectNo and" 
					+ " acs.CREDITOBJTYPE='CreditApply')))";
//					+ " and O.guarantyid in (select gfr.col_serialno from jbo.app.GUAR_FAC_RELA gfr where gfr.reffacobjid=:ObjectNo1 and gfr.reffacobjtype='CreditApply')";
			//这里只取o.COLASSETOWNER值
			//updateGuaranty(asUser,sObjectType,sObjectNo,sDocID,JBOFactory.getFactory().getManager("jbo.app.GUARANTY_INFO"),query,"guarantyid","COLASSETOWNER","09",today,tx);
			//再插入公司保证人信息：circleattr='10'
			query = "select O.guarantyid,o.COLASSETOWNER from O where O.certtype like 'Ent%' and  O.GuarantyID in (select"
					+ " GR.GuarantyID from "+GuarantyConst.GUARANTY_RELATIVE+" GR where GR.RelationStatus = '010' and GR.GCContractNo in (select gc.SerialNo"
					+ " from "+GuarantyConst.GUARANTY_CONTRACT+"  gc where gc.GUARANTYTYPE='010010' and gc.SerialNo in (select acs.GUR_SERIALNO from" 
					+ " jbo.app.AGR_CRE_SEC_RELA acs where acs.SerialNo=:ObjectNo and" 
					+ " acs.CREDITOBJTYPE='CreditApply')))";
//					+ " and O.guarantyid in (select gfr.col_serialno from jbo.app.GUAR_FAC_RELA gfr where gfr.reffacobjid=:ObjectNo1 and gfr.reffacobjtype='CreditApply')";
			//这里只取o.COLASSETOWNER值
			//updateGuaranty(asUser,sObjectType,sObjectNo,sDocID,JBOFactory.getFactory().getManager("jbo.app.GUARANTY_INFO"),query,"guarantyid","COLASSETOWNER","10",today,tx);
			//再插入保证人信息：circleattr='11',合并09和10,当个人和公司只不一起出现时可以替换09和10
			query = "select O.guarantyid,o.COLASSETOWNER from O where O.GuarantyID in (select"
					+ " GR.GuarantyID from "+GuarantyConst.GUARANTY_RELATIVE+" GR where GR.RelationStatus = '010' and GR.GCContractNo in (select gc.SerialNo"
					+ " from "+GuarantyConst.GUARANTY_CONTRACT+"  gc where gc.GUARANTYTYPE='010010' and gc.SerialNo in (select acs.GUR_SERIALNO from" 
					+ " jbo.app.AGR_CRE_SEC_RELA acs where acs.SerialNo=:ObjectNo and" 
					+ " acs.CREDITOBJTYPE='CreditApply')))";
//					+ " and O.guarantyid in (select gfr.col_serialno from jbo.app.GUAR_FAC_RELA gfr where gfr.reffacobjid=:ObjectNo1 and gfr.reffacobjtype='CreditApply')";
			//这里只取o.COLASSETOWNER值
			//updateGuaranty(asUser,sObjectType,sObjectNo,sDocID,JBOFactory.getFactory().getManager("jbo.app.GUARANTY_INFO"),query,"guarantyid","COLASSETOWNER","11",today,tx);
			
			//更新抵质押物信息
			//updateDZY(asUser,sObjectType,sObjectNo,sDocID);
			//TODO 根据FORMATDOC_PARA,FORMATDOC_DEF中的Attribute1 设置 (必填)
			//根据FORMATDOC_PARA,FORMATDOC_DEF中的Attribute1 设置 (必填)
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
	
	private void updateDZY(ASUser asUser,String sObjectType,String objectNo,String sDocID){
		BizObjectManager m = null;
		BizObjectManager m1 = null;
		BizObjectQuery q = null;
		String sSerialNo = "";//获得formatdoc_record.serialno
		try {
			BizObjectManager bmRecord = JBOFactory.getFactory().getManager("jbo.app.FORMATDOC_RECORD");
			BizObject objX = bmRecord.createQuery("DOCID=:DOCID and ObjectType=:ObjectType and ObjectNo=:ObjectNo")
				.setParameter("DOCID", sDocID)
				.setParameter("ObjectType", sObjectType)
				.setParameter("ObjectNo", objectNo)
				.getSingleResult();
			if(objX==null){
				throw new Exception("FORMATDOC_RECORD中找不到合适的记录");
			}
			sSerialNo = objX.getAttribute("SERIALNO").getString();
			
			m1 = JBOFactory.getFactory().getManager("jbo.app.FORMATDOC_DATA");
			q = m1.createQuery("select \"O.*\" from O where treeno like '12%' and relativeserialno=:SerialNo");
			q.setParameter("SerialNo", sSerialNo);
			List<BizObject> existNodes = q.getResultList();
			m = JBOFactory.getFactory().getManager(GuarantyConst.GUARANTY_INFO);
			q = m.createQuery("SELECT * FROM O,"+GuarantyConst.GUARANTY_RELATIVE+" REL,"+GuarantyConst.GUARANTY_CONTRACT+"  GC WHERE "
					+"O.GUARANTYID=REL.GUARANTYID AND GC.SERIALNO=REL.GCCONTRACTNO AND GC.SERIALNO IN "
					+"( SELECT AC.Gur_SerialNo FROM jbo.app.AGR_CRE_SEC_RELA AC WHERE AC.SerialNo=:SerialNo AND AC.CreditObjType = 'CreditApply') "
					+"AND O.GUARANTYTYPE LIKE '0010%' AND GC.GUARANTYTYPE='050' ");
//					+"and O.guarantyid in (select gfr.col_serialno from jbo.app.GUAR_FAC_RELA gfr where gfr.reffacobjid=:ObjectNo1 and gfr.reffacobjtype='CreditApply')");
			q.setParameter("SerialNo", objectNo);
//			q.setParameter("ObjectNo1", objectNo);
			List<BizObject> guarantys = q.getResultList();
			List<String> newNodes = new ArrayList<String>();
			if(guarantys.size() >0){
				newNodes.add("12");
				newNodes.add("1201");
				q = m.createQuery("select * from o where o.GUARANTYTYPE like '001000100020' and o.GUARANTYID in "
						+"(select gr.GuarantyID from "+GuarantyConst.GUARANTY_RELATIVE+" gr where gr.GCContractNo in "
						+"(select ac.Gur_SerialNo from jbo.app.AGR_CRE_SEC_RELA ac where ac.SerialNo=:SerialNo and ac.CreditObjType = 'CreditApply')) ");
//						+"and o.guarantyid in (select gfr.col_serialno from jbo.app.GUAR_FAC_RELA gfr where gfr.reffacobjid=:ObjectNo1 and gfr.reffacobjtype='CreditApply')");
				q.setParameter("SERIALNO",objectNo);
//				q.setParameter("ObjectNo1",objectNo);
				List<BizObject> rooms = q.getResultList();
				q = m.createQuery("select * from o where o.GUARANTYTYPE like '001000100010' and o.GUARANTYID in "
						+"(select gr.GuarantyID from "+GuarantyConst.GUARANTY_RELATIVE+" gr where gr.GCContractNo in "
						+"(select ac.Gur_SerialNo from jbo.app.AGR_CRE_SEC_RELA ac where ac.SerialNo=:SerialNo and ac.CreditObjType = 'CreditApply')) ");
//						+"and o.guarantyid in (select gfr.col_serialno from jbo.app.GUAR_FAC_RELA gfr where gfr.reffacobjid=:ObjectNo1 and gfr.reffacobjtype='CreditApply')");
				q.setParameter("SERIALNO",objectNo);
//				q.setParameter("ObjectNo1",objectNo);
				List<BizObject> earths = q.getResultList();
				q = m.createQuery("select * from o where o.GUARANTYTYPE like '001000200010' and o.GUARANTYID in "
						+"(select gr.GuarantyID from "+GuarantyConst.GUARANTY_RELATIVE+" gr where gr.GCContractNo in "
						+"(select ac.Gur_SerialNo from jbo.app.AGR_CRE_SEC_RELA ac where ac.SerialNo=:SerialNo and ac.CreditObjType = 'CreditApply')) ");
//						+"and o.guarantyid in (select gfr.col_serialno from jbo.app.GUAR_FAC_RELA gfr where gfr.reffacobjid=:ObjectNo1 and gfr.reffacobjtype='CreditApply')");
				q.setParameter("SERIALNO",objectNo);
//				q.setParameter("ObjectNo1",objectNo);
				List<BizObject> equips = q.getResultList();
				q = m.createQuery("select * from o where o.GUARANTYTYPE like '001000100030' and o.GUARANTYID in "
						+"(select gr.GuarantyID from "+GuarantyConst.GUARANTY_RELATIVE+" gr where gr.GCContractNo in "
						+"(select ac.Gur_SerialNo from jbo.app.AGR_CRE_SEC_RELA ac where ac.SerialNo=:SerialNo and ac.CreditObjType = 'CreditApply')) ");
//						+"and o.guarantyid in (select gfr.col_serialno from jbo.app.GUAR_FAC_RELA gfr where gfr.reffacobjid=:ObjectNo1 and gfr.reffacobjtype='CreditApply')");
				q.setParameter("SERIALNO",objectNo);
//				q.setParameter("ObjectNo1",objectNo);
				List<BizObject> builds = q.getResultList();
				q = m.createQuery("select * from o where o.GUARANTYTYPE like '0010%' and length(o.GUARANTYTYPE)>4 and o.GUARANTYTYPE not in "
						+"('001000100020','001000100010','001000200010','001000100030') and o.GUARANTYID in "
						+"(select gr.GuarantyID from "+GuarantyConst.GUARANTY_RELATIVE+" gr where gr.GCContractNo in "
						+"(select ac.Gur_SerialNo from jbo.app.AGR_CRE_SEC_RELA ac where ac.SerialNo=:SerialNo and ac.CreditObjType = 'CreditApply')) ");
//						+"and o.guarantyid in (select gfr.col_serialno from jbo.app.GUAR_FAC_RELA gfr where gfr.reffacobjid=:ObjectNo1 and gfr.reffacobjtype='CreditApply')");
				q.setParameter("SERIALNO",objectNo);
//				q.setParameter("ObjectNo1",objectNo);
				List<BizObject> otherss = q.getResultList();
				q = m.createQuery("SELECT * FROM O,"+GuarantyConst.GUARANTY_RELATIVE+" REL,"+GuarantyConst.GUARANTY_CONTRACT+"  GC WHERE O.GUARANTYID=REL.GUARANTYID AND "
						+"GC.SERIALNO=REL.GCCONTRACTNO AND GC.SERIALNO IN "
						+"( SELECT AC.Gur_SerialNo FROM jbo.app.AGR_CRE_SEC_RELA AC WHERE AC.SerialNo=:SerialNo and AC.CreditObjType = 'CreditApply') "
						+"AND O.GUARANTYTYPE LIKE '0020%' AND GC.GUARANTYTYPE='060' ");
//						+"and O.guarantyid in (select gfr.col_serialno from jbo.app.GUAR_FAC_RELA gfr where gfr.reffacobjid=:ObjectNo1 and gfr.reffacobjtype='CreditApply')");
				q.setParameter("SerialNo", objectNo);
//				q.setParameter("ObjectNo1",objectNo);
				List<BizObject> impawns = q.getResultList();
				if(rooms.size()>0){
					newNodes.add("1202");
				}if(earths.size()>0){
					newNodes.add("1203");
				}if(equips.size()>0){
					newNodes.add("1204");
				}if(builds.size()>0){
					newNodes.add("1205");
				}if(otherss.size()>0){
					newNodes.add("1206");
				}if(impawns.size()>0){
					newNodes.add("1207");
				}
			}else{
				q = m.createQuery("SELECT * FROM O,"+GuarantyConst.GUARANTY_RELATIVE+" REL,"+GuarantyConst.GUARANTY_CONTRACT+"  GC WHERE "
						+"O.GUARANTYID=REL.GUARANTYID AND GC.SERIALNO=REL.GCCONTRACTNO AND GC.SERIALNO IN "
						+"( SELECT AC.Gur_SerialNo FROM jbo.app.AGR_CRE_SEC_RELA AC WHERE AC.SerialNo=:SerialNo and AC.CreditObjType = 'CreditApply') "
						+"AND O.GUARANTYTYPE LIKE '0020%' AND GC.GUARANTYTYPE='060' ");
//						+"O.guarantyid in (select gfr.col_serialno from jbo.app.GUAR_FAC_RELA gfr where gfr.reffacobjid=:ObjectNo1 and gfr.reffacobjtype='CreditApply')");
				q.setParameter("SerialNo", objectNo);
//				q.setParameter("ObjectNo1",objectNo);
				List<BizObject> impawns = q.getResultList();
				if(impawns.size()>0){
					newNodes.add("12");
					newNodes.add("1207");
				}
			}
			if(newNodes.size()>0){
				for(int i=0;i<newNodes.size();i++){
					String node = newNodes.get(i);
					if(existNodes.size()>0){
						
						boolean isFlag = false;
						for(int j=0;j<existNodes.size();j++){
							BizObject exitNode = existNodes.get(j);
							String dirID = exitNode.getAttribute("DirID").getString();
							if(node.equals(dirID)){
								existNodes.remove(exitNode);
								isFlag = true;
								break;
							}
						}
						if(!isFlag){
							String dirName = "";
							BizObjectManager bmDef = JBOFactory.getFactory().getManager("jbo.app.FORMATDOC_DEF");
							BizObjectQuery bqDef = bmDef.createQuery("select DIRNAME from O where DOCID=:docid and DIRID=:DIRID").
									setParameter("docid", sDocID).setParameter("DIRID", node);
							BizObject docDef = bqDef.getSingleResult();
							if(docDef != null){
								dirName = docDef.getAttribute("DIRNAME").getString();
							}
							BizObject boData = m1.newObject();
							boData.setAttributeValue("RELATIVESERIALNO",sSerialNo);
							boData.setAttributeValue("TREENO",node);
							boData.setAttributeValue("DOCID",sDocID);
							boData.setAttributeValue("DIRID",node);
							boData.setAttributeValue("DIRNAME",dirName);
							boData.setAttributeValue("CONTENTLENGTH",0);
							boData.setAttributeValue("ORGID",asUser.getOrgID());
							boData.setAttributeValue("USERID",asUser.getUserID());
							boData.setAttributeValue("INPUTDATE", StringFunction.getToday());
							boData.setAttributeValue("UPDATEDATE", StringFunction.getToday());
							m1.saveObject(boData);
						}
					}else{
						String dirName = "";
						BizObjectManager bmDef = JBOFactory.getFactory().getManager("jbo.app.FORMATDOC_DEF");
						BizObjectQuery bqDef = bmDef.createQuery("select DIRNAME from O where DOCID=:docid and DIRID=:DIRID").
								setParameter("docid", sDocID).setParameter("DIRID", node);
						BizObject docDef = bqDef.getSingleResult();
						if(docDef != null){
							dirName = docDef.getAttribute("DIRNAME").getString();
						}
						BizObject boData = m1.newObject();
						boData.setAttributeValue("RELATIVESERIALNO",sSerialNo);
						boData.setAttributeValue("TREENO",node);
						boData.setAttributeValue("DOCID",sDocID);
						boData.setAttributeValue("DIRID",node);
						boData.setAttributeValue("DIRNAME",dirName);
						boData.setAttributeValue("CONTENTLENGTH",0);
						boData.setAttributeValue("ORGID",asUser.getOrgID());
						boData.setAttributeValue("USERID",asUser.getUserID());
						boData.setAttributeValue("INPUTDATE", StringFunction.getToday());
						boData.setAttributeValue("UPDATEDATE", StringFunction.getToday());
						m1.saveObject(boData);
					}
				}
				for(int k=0;k<existNodes.size();k++){
					m1.deleteObject((BizObject)existNodes.get(k));
				}
			}else{
				for(int i=0;i<existNodes.size();i++){
					m1.deleteObject((BizObject)existNodes.get(i));
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	protected boolean isExclude(String dirid){
		for(int i=0;i<excludeDirIds.length;i++){
			if(excludeDirIds[i].equals(dirid))
				return true;
		}
		return false;
	}
}
