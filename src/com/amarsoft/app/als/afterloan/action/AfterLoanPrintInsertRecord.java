package com.amarsoft.app.als.afterloan.action;

/**
 * by crfeng
 * 2015/3/13
 * 		
 */
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.json.JSONObject;

public class AfterLoanPrintInsertRecord {
	
	private JSONObject inputParameter;

	public void setInputParameter(JSONObject inputParameter){
		this.inputParameter = inputParameter;
	}
	
	public void insertPrintRecord(JBOTransaction tx) throws Exception{
		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.app.PUB_EDOC_PRINT");
		tx.join(bm);
		String serialNo = (String)inputParameter.getValue("SerialNo");
		String objectType = (String)inputParameter.getValue("ObjectType");
		String edocNo = (String)inputParameter.getValue("EDOCNO");
		BizObject pepbiz = bm.createQuery("O.ObjectNo = :ObjectNo and ObjectType = :ObjectType and O.EDOCNO = EdocNo").setParameter("ObjectNo", serialNo).
				setParameter("ObjectType", objectType).setParameter("EdocNo", edocNo).getSingleResult(true);
		String UserID = (String)inputParameter.getValue("UserId");//用户号
		String OrgID = (String)inputParameter.getValue("OrgId");//机构号
		if(pepbiz == null){
			BizObject pecbiz = JBOFactory.getBizObjectManager("jbo.app.PUB_EDOC_CONFIG").createQuery("O.EDOCNO = :EDOCNO and O.ISINUSE = '1'").setParameter("EDOCNO", edocNo).getSingleResult(true);
			String fileName = pecbiz.getAttribute("EDOCNAME").toString();
			BizObject bo = bm.newObject();
			
			bo.setAttributeValue("OBJECTNO", serialNo);
			bo.setAttributeValue("OBJECTTYPE", objectType);
			bo.setAttributeValue("EDOCNO", edocNo);
			bo.setAttributeValue("FILENAME", fileName);
			bo.setAttributeValue("INPUTUSER", UserID);
			bo.setAttributeValue("INPUTORG", OrgID);
			bo.setAttributeValue("INPUTTIME", DateHelper.getBusinessDate());
			bo.setAttributeValue("PRINTNUM","1");
			bm.saveObject(bo);
		}else{
			int printnum = pepbiz.getAttribute("PRINTNUM").getInt();
			printnum++;
			bm.createQuery("update O set O.INPUTUSER = :INPUTUSER,O.INPUTORG = :INPUTORG,"+
					"O.INPUTTIME = :INPUTTIME,O.PRINTNUM = :PRINTNUM where "+
					"O.ObjectNo = :ObjectNo and ObjectType = :ObjectType and O.EDOCNO = EdocNo"
					).setParameter("INPUTUSER", UserID).
					setParameter("INPUTORG", OrgID).
					setParameter("INPUTTIME", DateHelper.getBusinessDate()).
					setParameter("PRINTNUM",printnum).
					setParameter("ObjectNo", serialNo).
					setParameter("ObjectType", objectType).
					setParameter("EdocNo", edocNo).executeUpdate();
		}
		
	
	}
}
