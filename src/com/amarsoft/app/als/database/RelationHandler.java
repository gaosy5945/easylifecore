package com.amarsoft.app.als.database;

import java.util.List;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.dw.handler.impl.CommonHandler;
import com.amarsoft.awe.util.DBKeyHelp;

public class RelationHandler extends CommonHandler{

	/**
	 * @dlsong 2013-09-18
	 * 数据表关联关系详情页面数据获取方法
	 */
	
	//参数定义
	public String SerialNo="";
	public String Result="";
	public String TBName="";
	public String ColName1="";
	public String ColName2="";
	public String getResult() {
		return Result;
	}
	public String getTBName() {
		return TBName;
	}
	public void setTBName(String tBName) {
		TBName = tBName;
	}
	public String getColName1() {
		return ColName1;
	}
	public void setColName1(String colName1) {
		ColName1 = colName1;
	}
	public String getColName2() {
		return ColName2;
	}
	public void setColName2(String colName2) {
		ColName2 = colName2;
	}
	public void setResult(String result) {
		Result = result;
	}

	public String ViewNo="";
	public String getViewNo() {
		return ViewNo;
	}
	public void setViewNo(String viewNo) {
		ViewNo = viewNo;
	}
	public String getSerialNo() {
		return SerialNo;
	}
	public void setSerialNo(String serialNo) {
		SerialNo = serialNo;
	}
	
	//获取选取的数据表名
	public String GetRelaElement(JBOTransaction tx) throws JBOException{
		String sResult="";
		try{
			BizObjectManager bm=JBOFactory.getBizObjectManager("jbo.app.ALS_TABLE_RELATIVE");
			//tx.join(bm);
			BizObject bo=bm.createQuery("SerialNo=:SerialNo").setParameter("SerialNo", SerialNo).getSingleResult(false);
			String SourceTBName =bo.getAttribute("SourceTBName").toString().equals("")?"暂无":bo.getAttribute("SourceTBName").toString();
			String RelaTBName =bo.getAttribute("RelaTBName").toString().equals("")?"暂无":bo.getAttribute("RelaTBName").toString();
			String DestTBName =bo.getAttribute("DestTBName").toString().equals("")?"暂无":bo.getAttribute("DestTBName").toString();
			sResult=SourceTBName+"@"+RelaTBName+"@"+DestTBName;
			return sResult;
		}catch(Exception e){
			tx.rollback();
			return sResult; 
		}
	}
	
	//获取数据表对应的字段名
	public String GetSelect(JBOTransaction tx) throws JBOException{
		String sReturn1="";
		String availableTable="";
		String selectedTable="";
		String availableCol1="";
		String selectedCol1="";
		String availableCol2="";
		String selectedCol2="";
		try{
			BizObjectManager bm1=JBOFactory.getBizObjectManager("jbo.app.ALS_TABLE_RELATIVE");
			//tx.join(bm1);
			BizObject bo1=bm1.newObject();
			if(ViewNo.equals("1")){
				selectedTable=(String)(Result.split("@")[0]);
				bo1=bm1.createQuery("SerialNo=:SerialNo").setParameter("SerialNo", SerialNo).getSingleResult(false);
				if(selectedTable.equals(bo1.getAttribute("SourceTBName").toString())){
					selectedCol1=bo1.getAttribute("SourceCol").toString();
				}
			}else if(ViewNo.equals("2")){
				selectedTable=Result.split("@")[1];
				bo1=bm1.createQuery("SerialNo=:SerialNo").setParameter("SerialNo", SerialNo).getSingleResult(false);
				if(selectedTable.equals(bo1.getAttribute("RelaTBName").toString())){
					selectedCol1=bo1.getAttribute("Source4RelaCol").toString();
					selectedCol2=bo1.getAttribute("Dest4RelaCol").toString();
				}				
			}else{
				selectedTable=Result.split("@")[2];
				bo1=bm1.createQuery("SerialNo=:SerialNo").setParameter("SerialNo", SerialNo).getSingleResult(false);
				if(selectedTable.equals(bo1.getAttribute("DestTBName").toString())){
					selectedCol1=bo1.getAttribute("DestCol").toString();
				}				
			}
			BizObjectManager bm2=JBOFactory.getBizObjectManager("jbo.app.ALS_TABLE");
			//tx.join(bm2);
			List ls=bm2.createQuery("TBNO <> :TBNO").setParameter("TBNO", selectedTable).getResultList();
			for(int i=0;i<ls.size();i++){
				availableTable+="@"+((BizObject)ls.get(i)).getAttribute("TBNO").toString();
			}
			availableTable=availableTable.substring(1);
			BizObjectManager bm3=JBOFactory.getBizObjectManager("jbo.app.ALS_TABLE_METADATA");
			//tx.join(bm3);
			List ls1=bm3.createQuery("TBNAME = :TBNAME").setParameter("TBNAME", selectedTable).getResultList();
			for(int i=0;i<ls1.size();i++){
				String tempavailable=((BizObject)ls1.get(i)).getAttribute("TBCOL").toString();
				if(selectedCol1.indexOf(tempavailable) == -1){
					availableCol1+="@"+tempavailable;
				}
			}
			
			if( availableCol1 != "" ){
				availableCol1=availableCol1.substring(1);				
			}
			availableCol2=availableCol1;
			sReturn1=availableTable+";"+selectedTable+";"+availableCol1+";"+selectedCol1+";"+availableCol2+";"+selectedCol2;
			return sReturn1;
		}catch(Exception e){
			return sReturn1;
		}
	}
	
	//更新ALS_TABLE_RELATIVE，保存修改结果
	public void save(JBOTransaction tx) throws JBOException{
		BizObjectManager bm=JBOFactory.getBizObjectManager("jbo.app.ALS_TABLE_RELATIVE");
		if(ViewNo.equals("1")){
			BizObjectQuery bq=bm.createQuery("Update o set SourceTBName=:TBNO, SourceCol=:TBCol where SerialNo=:SerialNo").setParameter("TBNO", TBName).setParameter("TBCol", ColName1).setParameter("SerialNo", SerialNo);
			bq.executeUpdate();
			BizObjectQuery bq1=bm.createQuery("Update o set DestTBName=:TBNO, DestCol=:TBCol where RelativeSerialNo=:SerialNo").setParameter("TBNO", TBName).setParameter("TBCol", ColName1).setParameter("SerialNo", SerialNo);
			bq1.executeUpdate();
		}else if(ViewNo.equals("2")){
			BizObjectQuery bq=bm.createQuery("Update o set RelaTBName=:TBNO, Source4RelaCol=:TBCol, Dest4RelaCol=:TBCol1 where SerialNo=:SerialNo").setParameter("TBNO", TBName).setParameter("TBCol", ColName1).setParameter("TBCol1", ColName2).setParameter("SerialNo", SerialNo);
			bq.executeUpdate();
			BizObjectQuery bq1=bm.createQuery("Update o set RelaTBName=:TBNO, Dest4RelaCol=:TBCol, Source4RelaCol=:TBCol1 where RelativeSerialNo=:SerialNo").setParameter("TBNO", TBName).setParameter("TBCol", ColName1).setParameter("TBCol1", ColName2).setParameter("SerialNo", SerialNo);
			bq1.executeUpdate();
		}else{
			BizObjectQuery bq=bm.createQuery("Update o set DestTBName=:TBNO, DestCol=:TBCol where SerialNo=:SerialNo").setParameter("TBNO", TBName).setParameter("TBCol", ColName1).setParameter("SerialNo", SerialNo);
			bq.executeUpdate();
			BizObjectQuery bq1=bm.createQuery("Update o set SourceTBName=:TBNO, SourceCol=:TBCol where RelativeSerialNo=:SerialNo").setParameter("TBNO", TBName).setParameter("TBCol", ColName1).setParameter("SerialNo", SerialNo);
			bq1.executeUpdate();
		}
	}
	
	public void afterInsert(JBOTransaction tx, BizObject bo) throws Exception{
		try{
			//新增关联记录
			String sSerialNo=bo.getAttribute("SerialNo").toString();
			BizObjectManager bm=JBOFactory.getBizObjectManager("jbo.app.ALS_TABLE_RELATIVE");
			tx.join(bm);
			BizObject bo1=bm.newObject();
			String sSerialNo1= DBKeyHelp.getSerialNo("ALS_TABLE_RELATIVE","SerialNo");
			bo1.setAttributeValue("UpdateDate",StringFunction.getToday());
			bo1.setAttributeValue("SerialNo", sSerialNo1);
			bo1.setAttributeValue("RelativeSerialNo", sSerialNo);
			bo1.setAttributeValue("SourceTBName",bo.getAttribute("DestTBName").toString());
			bo1.setAttributeValue("SourceCol",bo.getAttribute("DestCol").toString());
			bo1.setAttributeValue("Source4RelaCol",bo.getAttribute("Dest4RelaCol").toString());
			bo1.setAttributeValue("RelaTBName",bo.getAttribute("RelaTBName").toString());
			bo1.setAttributeValue("Dest4RelaCol",bo.getAttribute("Source4RelaCol").toString());
			bo1.setAttributeValue("DestTBName",bo.getAttribute("SourceTBName").toString());
			bo1.setAttributeValue("DestCol",bo.getAttribute("SourceCol").toString());
			bm.saveObject(bo1);
			//更新新增记录的RelativeSerialNo
			BizObjectQuery bq=bm.createQuery("Update o set RelativeSerialNo=:RelativeSerialNo where SerialNo=:SerialNo").setParameter("RelativeSerialNo", sSerialNo1).setParameter("SerialNo", sSerialNo);
			bq.executeUpdate();
		}catch(Exception e){
			tx.rollback();
		}
	}
	
	public void afterDelete(JBOTransaction tx, BizObject bo) throws Exception{
		try{
			String sSerialNo=bo.getAttribute("SerialNo").toString();
			BizObjectManager bm=JBOFactory.getBizObjectManager("jbo.app.ALS_TABLE_RELATIVE");
			tx.join(bm);
			BizObjectQuery bq=bm.createQuery("Delete from o where RelativeSerialNo=:SerialNo").setParameter("SerialNo",sSerialNo);
			bq.executeUpdate();
		}catch(Exception e){
			tx.rollback();			
		}
	}

}