package com.amarsoft.app.urge;

import java.util.Date;
import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.app.als.customer.model.CustomerConst;
import com.amarsoft.app.als.reserve.model.ReserveApply;
import com.amarsoft.app.als.reserve.model.ReservePredictdata;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.DateX;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.awe.dw.handler.impl.CommonHandler;
import com.amarsoft.awe.util.DBKeyHelp;
import com.amarsoft.dict.als.manage.NameManager;
/**
 * ������յǼ���Ϣ
 * @author T-liuzq
 *
 */
public class OutCollRegistrateInfoHandler extends CommonHandler  {

	/**
	 * ������ʼ��
	 * 
	 * @param bo
	 * @throws Exception
	 */
	protected void initDisplayForAdd(BizObject bo) throws Exception {
		String sPTISerialNo = asPage.getParameter("PTISerialNo");
		String sCTSerialNo = asPage.getParameter("CTSerialNo");

		BizObjectManager bm2=JBOFactory.getBizObjectManager("jbo.coll.COLL_TASK");
		BizObject bo2 = bm2.createQuery("  SERIALNO=:SERIALNO ").setParameter("SERIALNO", sPTISerialNo).getSingleResult(false); 
		if(bo2==null){                
		} else {
			bo.setAttributeValue("OBJECTTYPE", bo2.getAttribute("OBJECTTYPE").getString());
			bo.setAttributeValue("OBJECTTYPE", bo2.getAttribute("OBJECTTYPE").getString());
			bo.setAttributeValue("TASKBATCHNO", bo2.getAttribute("TASKBATCHNO").getString());
		}  
		bo.setAttributeValue("PROCESSDATE", DateX.format(new Date()));
		bo.setAttributeValue("INPUTDATE", DateX.format(new Date()));
		bo.setAttributeValue("INPUTUSERID", curUser.getUserID());
		bo.setAttributeValue("INPUTORGID", curUser.getOrgID());
		bo.setAttributeValue("INPUTUSERNAME", curUser.getUserName());
		bo.setAttributeValue("INPUTORGNAME", curUser.getOrgName());
		bo.setAttributeValue("TASKSERIALNO", sCTSerialNo);
		bo.setAttributeValue("TASKBATCHNO", sPTISerialNo);
		//bo.setAttributeValue("OPERATEDATE", curUser.getOrgName());//ί������
		//bo.setAttributeValue("ACTUALFINISHDATE", curUser.getOrgName());//�᰸����
		bo.setAttributeValue("SERIALNO", DBKeyHelp.getSerialNo("COLL_TASK_PROCESS","serialNo",""));
		super.initDisplayForAdd(bo);
	}

	/**
	 * �༭�����£���ʼ��
	 * 
	 * @param bo
	 * @throws Exception
	 */
	protected void initDisplayForEdit(BizObject bo) throws Exception {
		//bo.setAttributeValue("INPUTUSERNAME", NameManager.getUserName(bo.getAttribute("INPUTUSERID").getString()));
		//bo.setAttributeValue("OPERATEUSERNAME",NameManager.getUserName(bo.getAttribute("OPERATEUSERID").getString()));
	}

	/**
	 * ����ǰִ���¼�
	 * @param tx
	 * @param bo
	 * @throws Exception
	 */
	protected void beforeInsert(JBOTransaction tx, BizObject bo) throws Exception {
		//String sPTISerialNo = "";
		String sPTISerialNo = asPage.getParameter("PTISerialNo");
		String sCTSerialNo = asPage.getParameter("CTSerialNo");
		try{
			//sPTISerialNo = inserPubTaskInfo(tx);
			bo.setAttributeValue("TASKBATCHNO", sPTISerialNo);
			bo.setAttributeValue("TASKSERIALNO", sCTSerialNo);
		}catch(Exception e){
			e.printStackTrace();
			deletePTI(tx,sPTISerialNo);
		}
	}
	
	/**
	 * ����������PUB_TASK_INFO
	 * @param 
	 * @throws Exception 
	 */
  	private String inserPubTaskInfo(JBOTransaction tx) throws Exception{
  		BusinessObjectManager businessObjectManager;
  		businessObjectManager =  BusinessObjectManager.createBusinessObjectManager(tx);
		String sPTISerialNo = "";
		String sUserId = curUser.getUserID();
		String sOrgId = curUser.getOrgID();
		try{
			BusinessObject todo = BusinessObject.createBusinessObject("jbo.app.PUB_TASK_INFO");
			//businessObjectManager.generateObjectNo(todo);
			todo.setAttributeValue("SERIALNO", DBKeyHelp.getSerialNo("PUB_TASK_INFO","SerialNo",""));//���
			todo.setAttributeValue("TASKTYPE", "�������");//
			todo.setAttributeValue("OPERATEDESCRIPTION", "");//
			todo.setAttributeValue("OPERATEDATE", DateHelper.getBusinessDate());
			todo.setAttributeValue("OPERATEUSERID", sUserId);
			todo.setAttributeValue("OPERATEORGID", sOrgId);
			todo.setAttributeValue("STATUS", "01");
			businessObjectManager.updateBusinessObject(todo);
			businessObjectManager.updateDB();//����PUB_TASK_INFO��Ϣ
			sPTISerialNo = todo.getString("SERIALNO");
			return sPTISerialNo;
		} catch(Exception e){
			e.printStackTrace();
			return "";
		}
  	}	
  	/**
  	 * ɾ��PTI��Ϣ
  	 * @param tx
  	 * @param sPTISerialNo
  	 * @return
  	 * @throws Exception
  	 */
  	private void deletePTI(JBOTransaction tx,String sPTISerialNo) throws Exception{
		try{
			BizObjectManager m = JBOFactory.getFactory().getManager("jbo.app.PUB_TASK_INFO");
		    tx.join(m);
			BizObjectQuery bq = m.createQuery("delete O where serialno=:serialno");
			bq.setParameter("serialno",sPTISerialNo).executeUpdate();	
		} catch(Exception e){
			e.printStackTrace();
		}
  	}	
	/**
	 * �����ִ���¼� ����CT������PTI
	 * @param tx
	 * @param bo
	 * @throws Exception
	 */
	protected void afterInsert(JBOTransaction tx, BizObject bo)
			throws Exception {
		//����PTI ����CT
		try{
			//BizObjectManager m = JBOFactory.getFactory().getManager("jbo.app.PUB_TASK_INFO");
		    //tx.join(m);
			//BizObjectQuery bq = m.createQuery("update O set Status=:Status,OPERATEDATE=:OPERATEDATE,ACTUALFINISHDATE=:ACTUALFINISHDATE where serialno=:serialno");
			//bq.setParameter("Status","02").setParameter("OPERATEDATE",OPERATEDATE).setParameter("ACTUALFINISHDATE",ACTUALFINISHDATE).setParameter("serialno",sPTISerialNo).executeUpdate();	
			
			String sCTSerialNo = bo.getAttribute("TASKSERIALNO").getString();
			String CONTACTRESULT = bo.getAttribute("CONTACTRESULT").getString(); 
			String ENTRUSTDATE = bo.getAttribute("ENTRUSTDATE").getString(); 
			String ENTRUSTENDDATE = bo.getAttribute("ENTRUSTENDDATE").getString(); 

			BizObjectManager m1 = JBOFactory.getFactory().getManager("jbo.coll.COLL_TASK");
		    tx.join(m1);
			BizObjectQuery bq1 = m1.createQuery("update O set Status=:Status,COLLECTIONRESULT=:COLLECTIONRESULT,ENTRUSTDATE=:ENTRUSTDATE,ENTRUSTENDDATE=:ENTRUSTENDDATE  where serialno=:serialno");
			bq1.setParameter("Status","2")
			.setParameter("COLLECTIONRESULT",CONTACTRESULT)
			.setParameter("ENTRUSTDATE",ENTRUSTDATE)
			.setParameter("ENTRUSTENDDATE",ENTRUSTENDDATE)
			.setParameter("serialno",sCTSerialNo)
			.executeUpdate();	
			
		}catch(Exception e){
			e.printStackTrace();
		}
	}

	/**
	 * ����ǰ�¼�
	 * @param tx
	 * @param bo
	 * @throws Exception
	 */
	protected void beforeUpdate(JBOTransaction tx, BizObject bo)
			throws Exception {
	}

	/**
	 * ���º��¼�
	 * @param tx
	 * @param bo
	 * @throws Exception
	 */
	protected void afterUpdate(JBOTransaction tx, BizObject bo)
			throws Exception {
		String sCTSerialNo = bo.getAttribute("TASKSERIALNO").getString();
		String CONTACTRESULT = bo.getAttribute("CONTACTRESULT").getString(); 
		String ENTRUSTDATE = bo.getAttribute("ENTRUSTDATE").getString(); 
		String ENTRUSTENDDATE = bo.getAttribute("ENTRUSTENDDATE").getString(); 

		BizObjectManager m1 = JBOFactory.getFactory().getManager("jbo.coll.COLL_TASK");
	    tx.join(m1);
		BizObjectQuery bq1 = m1.createQuery("update O set Status=:Status,COLLECTIONRESULT=:COLLECTIONRESULT,ENTRUSTDATE=:ENTRUSTDATE,ENTRUSTENDDATE=:ENTRUSTENDDATE  where serialno=:serialno");
		bq1.setParameter("Status","2")
		.setParameter("COLLECTIONRESULT",CONTACTRESULT)
		.setParameter("ENTRUSTDATE",ENTRUSTDATE)
		.setParameter("ENTRUSTENDDATE",ENTRUSTENDDATE)
		.setParameter("serialno",sCTSerialNo)
		.executeUpdate();	
	}

}
