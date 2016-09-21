package com.amarsoft.app.als.dataimport.bill;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Map;

import com.amarsoft.app.als.dataimport.BillConst;
import com.amarsoft.app.als.dataimport.xlsimport.AbstractExcelImport;
import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.DataElement;
import com.amarsoft.are.lang.DateX;
/**
 * Ʊ�ݵ���ҵ������
 * @author amarsoft
 *
 */
public class BillExcelImport extends AbstractExcelImport {
	private int icount=1;
	private JBOTransaction trans;
	private boolean rollBack = false;
	BizObjectManager bm;
	private int mcount=0;
	public void start(JBOTransaction tx) {
		trans = tx;
		try {
			bm = JBOFactory.getBizObjectManager(BillConst.BILL_INFO);
			trans.join(bm);
		} catch (JBOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	public boolean process(Map<String, DataElement> excelMap) {
		boolean flag = true;
		try {
			BizObject bo = bm.newObject();
		    String[] billString=new String[]{"ISLOCALBILL","BILLNO","BILLSUM",
		    		                                                     "WRITEDATE","MATURITY","FINISHDATE","BEGINDATE","HOLDERID",
		    		                                                     "ENDORSETIMES","RATE","AcceptorID","DEDUCTACCNO"
		                                                                  };

		    String[] billStringName=new String[]{"�Ƿ���Ʊ��","Ʊ�ݺ���","Ʊ����","Ʊ��ǩ����","Ʊ�ݵ�����","��������","Ʊ�ݲ�ѯ�ظ�����",
		    	                                                                       "Ʊ����Դ","��������","����������","�ж����к�","�ſ��˺�"};
		    mcount++;
		    for(int i=0;i<billString.length;i++){
		           if(excelMap.get(billString[i])==null){
		        	   writeLog("��"+mcount+"�����ݵ�"+"["+billStringName[i]+"]"+"�Ǳ������дδ��ɣ�");
		        	   return false;
		           }
		    }
			String billNo = excelMap.get("BILLNO").getString();
			String isLocalbill = excelMap.get("ISLOCALBILL").getString();
			String billSum = excelMap.get("BILLSUM").getString();
			String writeDate = excelMap.get("WRITEDATE").getString();
			String maturity = excelMap.get("MATURITY").getString();
			String finishDate = excelMap.get("FINISHDATE").getString();
			String beginDate = excelMap.get("BEGINDATE").getString();
			String holderID = excelMap.get("HOLDERID").getString();
			String endorseTimes = excelMap.get("ENDORSETIMES").getString();
			String rate = excelMap.get("RATE").getString();
			String acceptorBankID = excelMap.get("AcceptorID").getString();
			String deductaccNo = excelMap.get("DEDUCTACCNO").getString();
			//У��
			int count = bm.createQuery("BillNo=:BillNo and FinishDate is not null and FinishDate <> ' ' and ObjectType = :ObjectType and ObjectNo = :ObjectNo").setParameter("BillNo",billNo).setParameter("ObjectType",getParameter("ObjectType")).setParameter("ObjectNo",getParameter("ObjectNo")).getTotalCount();
			if(count > 0){
				writeLog("��"+icount+"�����ݡ�Ʊ�ݺ�:" + billNo + "���Ѵ��ڣ����飡");
				flag = false;
    			rollBack = true;
			}
			try
    		{
    			Double.parseDouble(billSum);
    		}
    		catch(Exception ex)
    		{
    			writeLog("��"+icount+"�����ݡ�Ʊ�ݽ�����");
    			flag = false;
    			rollBack = true;
    		}
			if(!dateCheck(writeDate))
    		{
				writeLog("��"+icount+"�����ݡ�Ʊ��ǩ���ա�δ����YYYY/MM/DD��ʽ��д��");
    			flag = false;
    			rollBack = true;
    		}
			if(!dateCheck(finishDate))
    		{
				writeLog("��"+icount+"�����ݡ��������ڡ�δ����YYYY/MM/DD��ʽ��д��");
    			flag = false;
    			rollBack = true;
    		}
			if(!dateCheck(beginDate))
    		{
				writeLog("��"+icount+"�����ݡ�Ʊ�ݲ�ѯ�ظ����ڡ�δ����YYYY/MM/DD��ʽ��д��");
    			flag = false;
    			rollBack = true;
    		}
			if(!dateCheck(maturity))
    		{
				writeLog("��"+icount+"�����ݡ�Ʊ�ݵ����ա�δ����YYYY/MM/DD��ʽ��д��");
    			flag = false;
    			rollBack = true;
    		}
//			try
//    		{
//    			Integer.parseInt(endorseTimes);
//    		}
//    		catch(Exception ex)
//    		{
//    			writeLog("��"+icount+"�����ݡ���������������");
//    			flag = false;
//    			rollBack = true;
//    		}
    		
    		try
    		{
    			Double.parseDouble(rate);
    		}
    		catch(Exception ex)
    		{
    			writeLog("��"+icount+"�����ݡ�����������(��)������");
    			flag = false;
    			rollBack = true;
    		}
			
			if(flag){
				bo.setAttributeValue("BILLNO", billNo);
				bo.setAttributeValue("ISLOCALBILL", isLocalbill);
				bo.setAttributeValue("BILLSUM", billSum);
				bo.setAttributeValue("WRITEDATE", writeDate);
				bo.setAttributeValue("MATURITY", maturity);
				bo.setAttributeValue("FINISHDATE", finishDate);
				bo.setAttributeValue("BEGINDATE", beginDate);
				bo.setAttributeValue("HOLDERID", holderID);
				bo.setAttributeValue("ENDORSETIMES", endorseTimes);
				bo.setAttributeValue("RATE", rate);
				bo.setAttributeValue("AcceptorID", acceptorBankID);
				bo.setAttributeValue("DEDUCTACCNO", deductaccNo);
				bo.setAttributeValue("INPUTUSERID", CurUser.getUserID());
				bo.setAttributeValue("INPUTORGID", CurUser.getOrgID());
				bo.setAttributeValue("INPUTDATE", DateX.format(new Date()));
				bo.setAttributeValue("UPDATEDATE", DateX.format(new Date()));
				bo.setAttributeValue("OBJECTTYPE", getParameter("ObjectType"));
				bo.setAttributeValue("OBJECTNO", getParameter("ObjectNo"));
				bm.saveObject(bo);
			}
			icount++;
		} catch (JBOException e) {
			rollBack = true;
			e.printStackTrace();
		}
		return flag;
	}

	public void end() {
		if(rollBack){
			try {
				trans.rollback();
			} catch (JBOException e) {
				ARE.getLog("����ع�����");
			}
		}else{
			try {
				trans.commit();
			} catch (JBOException e) {
				ARE.getLog("�����ύ����");
			}
		}
	}
	
	private  boolean dateCheck(String data){
		try {
	        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy/MM/dd");
	        dateFormat.setLenient(false);
	        Date d = dateFormat.parse(data);
	        return true;
		}catch (Exception e) {
			return false;
		}
	}

}
