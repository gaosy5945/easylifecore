package com.amarsoft.app.oci.instance;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import com.amarsoft.app.oci.OCIConfig;
import com.amarsoft.app.oci.bean.Field;
import com.amarsoft.app.oci.bean.Message;
import com.amarsoft.app.oci.bean.OCITransaction;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.DataElement;

import java.sql.Connection;

public class DecisionInstance {
	public static String SingleQuery(Map paraHashMap , Map paraHashMap1 ,  Connection conn) throws SQLException, Exception{
		OCITransaction transactionReq=OCIConfig.getTransactionByClientID("DECISION_QUERY",conn);
		transactionReq.fillMessage(paraHashMap, paraHashMap1, null);
		transactionReq.getCommunicator().execute();
		return transactionReq.getRequestData().toString();
	}
	
	public static String SingleQuery(String serialNO,JBOTransaction tx ) throws Exception{
		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.rds.INMESSAGE");
		tx.join(bm);
		BizObject bo = bm.createQuery("SERIALNO=:SERIALNO").setParameter("SERIALNO", serialNO) .getSingleResult(false);
		OCITransaction transactionReq = OCIConfig.getTransactionByClientID("DECISION_QUERY",null);
		transactionReq.fillMessage(new HashMap(), getParaMap(transactionReq , bo), null);
		transactionReq.getCommunicator().execute();
		SaveBo(transactionReq,bo,tx);
		return transactionReq.getRequestData().toString();
	}
	
	private static Map getParaMap(OCITransaction transactionReq, BizObject bo) throws JBOException{
		ArrayList<Map> list1 = getList1(transactionReq , bo);
		ArrayList<Map> list2 = getList2(transactionReq , bo);
		Map paraHashMap1 = new LinkedHashMap();			
		paraHashMap1.put("Decision_ControlField", list1);
		paraHashMap1.put("Decision_InputFieldsField", list2);
		return paraHashMap1;
	}
	
	private static ArrayList getList1(OCITransaction transactionReq, BizObject bo) throws JBOException{
		ArrayList<Map> list1 = new ArrayList<Map>();
		Map temp = new HashMap<String, String>();
		String[] array = transactionReq.getProperty("Controle").split(",");
		for(String ss : array){
			temp = new HashMap<String, String>();
			temp.put("Field", bo.getAttribute(ss));
			temp.put("Name", ss);
			list1.add(temp);
		}
		return list1;
	}
	
	private static ArrayList getList2(OCITransaction transactionReq, BizObject bo) throws JBOException{
		ArrayList<Map> list1 = new ArrayList<Map>();
		Map temp = new HashMap<String, String>();
		String except = transactionReq.getProperty("Controle") + "," + transactionReq.getProperty("Exception");
		DataElement[] arrays = bo.getAttributes();
		for(DataElement data : arrays){
			if(except.contains(data.getName())) continue;
			temp = new HashMap<String, String>();
			temp.put("Name", data.getName());
			temp.put("Type", (data.getType() == 0 ?"String" : "Number"));
			temp.put("Field", bo.getAttribute(data.getName()));
			list1.add(temp);
		}
		return list1;
	}
	
	private static void SaveBo(OCITransaction tran,BizObject in,JBOTransaction tx) throws JBOException{
		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.rds.OUTMESSAGE");
		tx.join(bm);
		BizObject bo = bm.newObject();
		Message messgae = tran.getOMessage("decision_out");
		Field[] fields =  messgae.getFields();
		for(Field field : fields){
			Message mFrist = field.getObjectMessage();
			for(Field fFrst : mFrist.getFields() ){
				List<Message> list = fFrst.getFieldArrayValue();
				if (list != null){
					for(Message mSec : list){
						Field[] fieldSource = mSec.getFields();
						for(Field fSec : fieldSource){
							bo.setAttributeValue(fSec.getAttributes().get(0).getFieldValue(), fSec.getFieldValue());
						}
					}
				}
			}
		}
		bo.setAttributeValue("ObjectNo", in.getAttribute("ObjectNo").getString());
		bo.setAttributeValue("SerialNo", in.getAttribute("SerialNo").getString());
		bo.setAttributeValue("ObjectType", in.getAttribute("ObjectType").getString());
		bo.setAttributeValue("CallType", "0"+in.getAttribute("decisionFlg").getString()); 
		bm.saveObject(bo);
	}
}
