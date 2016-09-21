package com.amarsoft.app.als.colltask.action;
	/**
	 * 功能：贷后催收新增时在COLL_TASK和COLL_TASK_PROCESS中插入记录
	 * 		张万亮
	 */
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.json.JSONObject;

	public class InsertCollTask {
		private JSONObject inputParameter;
		private BusinessObjectManager businessObjectManager;
		public void setInputParameter(JSONObject inputParameter){
			this.inputParameter = inputParameter;
		}
		
		private JBOTransaction tx;

		public void setTx(JBOTransaction tx){
			this.tx = tx;
		}
		
		public void setBusinessObjectManager(BusinessObjectManager businessObjectManager){
			this.businessObjectManager = businessObjectManager;
			this.tx = businessObjectManager.getTx();
		}
		
		public void insertCollTask(JBOTransaction tx) throws Exception{
			BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.coll.COLL_TASK");
			tx.join(bm);
			String serialNo = (String)inputParameter.getValue("SerialNo");
			String inputUserID = (String)inputParameter.getValue("InputUserID");
			String inputOrgID = (String)inputParameter.getValue("InputOrgID");
			String objectType = (String)inputParameter.getValue("ObjectType");
			String SerialNo = "";
			BizObject bo = bm.newObject();
			
			bo.setAttributeValue("OBJECTNO", serialNo);
			bo.setAttributeValue("OBJECTTYPE", objectType);
			//bo.setAttributeValue("STATUS", "1");
			bo.setAttributeValue("CREATETYPE", "2");
			bo.setAttributeValue("OPERATEUSERID", inputUserID);
			bo.setAttributeValue("OPERATEORGID", inputOrgID);
			bo.setAttributeValue("OPERATEDATE", DateHelper.getBusinessDate());
			bo.setAttributeValue("INPUTUSERID", inputUserID);
			bo.setAttributeValue("INPUTORGID", inputOrgID);
			bo.setAttributeValue("INPUTDATE", DateHelper.getBusinessDate());
			bm.saveObject(bo);
			SerialNo = bo.getAttribute("SerialNo").toString();
		}
		
		public void finishCollTask(JBOTransaction tx) throws Exception{ 
			String serialNo = (String)inputParameter.getValue("SerialNo");
			BizObjectManager bm=JBOFactory.getBizObjectManager("jbo.coll.COLL_REPAYMENT_SCHEDULE");
			//BizObjectQuery boq = bm.createQuery("DocumentObjectType=:DocumentObjectType and DocumentObjectNo=:DocumentObjectNo and ParentTransSerialNo= :ParentTransSerialNo");
			BizObjectQuery boq = bm.createQuery("COLLECTIONTASKSERIALNO=:COLLECTIONTASKSERIALNO");
			boq.setParameter("COLLECTIONTASKSERIALNO", serialNo);
			//boq.setParameter("ParentTransSerialNo", parentTransSerialNo);
			BizObject bo = boq.getSingleResult(false);
			String sRepayDate="";
			if(bo!=null)
			{
				sRepayDate = bo.getAttribute("REPAYDATE").getString();
			}
			BizObjectManager bm1 = JBOFactory.getBizObjectManager("jbo.coll.COLL_TASK");
			tx.join(bm1);
			if("".equals(sRepayDate)){
				bm1.createQuery("UPDATE O SET STATUS = '2' WHERE SERIALNO = :SERIALNO")
				.setParameter("SERIALNO", serialNo).executeUpdate();
			}else{
				bm1.createQuery("UPDATE O SET STATUS = '3' WHERE SERIALNO = :SERIALNO")
				.setParameter("SERIALNO", serialNo).executeUpdate();
			}
			
		}
		
		public void updateCollTask(JBOTransaction tx) throws Exception{
			BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.coll.COLL_TASK");
			tx.join(bm);
			String serialNo = (String)inputParameter.getValue("SerialNo");
			String CONTACTMETHOD=(String)inputParameter.getValue("CONTACTMETHOD");
			String CONTACTRESULT=(String)inputParameter.getValue("CONTACTRESULT");
			String EXPLANATIONCODE=(String)inputParameter.getValue("EXPLANATIONCODE");
			String PROCESSUSERID=(String)inputParameter.getValue("PROCESSUSERID");
			bm.createQuery("UPDATE O SET COLLECTIONMETHOD=:COLLECTIONMETHOD,COLLECTIONRESULT=:COLLECTIONRESULT,EXPLANATIONCODE=:EXPLANATIONCODE,OPERATEUSERID=:OPERATEUSERID "
					+ " WHERE SERIALNO = :SERIALNO ")
					.setParameter("COLLECTIONMETHOD", CONTACTMETHOD)
					.setParameter("COLLECTIONRESULT", CONTACTRESULT)
					.setParameter("EXPLANATIONCODE", EXPLANATIONCODE)
					.setParameter("OPERATEUSERID", PROCESSUSERID)
					.setParameter("SERIALNO", serialNo)
					.executeUpdate();
		}
}
