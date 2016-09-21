package com.amarsoft.app.creditline.bizlets;

import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.dw.handler.impl.CommonHandler;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.DBKeyHelp;
import com.amarsoft.awe.util.SqlObject;

public class AddCLApplyHandler extends CommonHandler {
	

	@Override
	protected void initDisplayForAdd(BizObject bo) throws Exception {
		// TODO Auto-generated method stub
		String[][] defaultFields = { { "CycleFlag", "2" },{"BusinessCurrency","01"} ,{"VouchType","010"}};

	    for (int i = 0; i < defaultFields.length; i++)
	      try
	      {
	        bo.setAttributeValue(defaultFields[i][0], defaultFields[i][1]);
	      }
	      catch (Exception e)
	      {
	      }
	   	
		super.initDisplayForAdd(bo);
	}

	@Override
	protected void afterInsert(JBOTransaction tx, BizObject bo)
			throws Exception {
		// TODO Auto-generated method stub
		        BizObjectManager bm1 = null;   
		        BizObjectManager bm2 = null;  
		        BizObjectManager bm3= null; 
		        BizObjectManager bm4= null; 
		        BizObjectManager bm5= null; 
		        BizObjectManager bm6= null; 
		        BizObjectManager bm7= null; 
	            String sObjectType = "CreditApply";
		        String sObjectNo=bo.getAttribute("SerialNo").getString();
				//��������
				String sApplyType=bo.getAttribute("ApplyType").getString();
				//���̱��
				 String sFlowNo = asPage.getParameter("FlowNo");
				//�׶α��
				 String sPhaseNo = asPage.getParameter("PhaseNo");
				//�û�����
				String sUserID=bo.getAttribute("InputUserID").getString();
				//��������
				String sOrgID=bo.getAttribute("InputOrgID").getString();
				//�������:�û����ơ��������ơ��������ơ��׶����ơ��׶����͡���ʼʱ�䡢������ˮ�š�SQL
				String sUserName = "";
				String sOrgName = "";
				String sFlowName = "";
				String sPhaseName = "";	
				String sPhaseType = "";
				String sBeginTime = "";
				String sSerialNo = "";
				String sSql = "";
				//�����������ѯ�����
				ASResultSet rs=null;
				SqlObject so;
				// add by fhuang  ����ͻ���������С��ҵ��ʹ������ģ�� SMECreditFlow
				if(sObjectType == null) sObjectType = "";
			
				if(sObjectType.equals("CreditApply")){
					//�ҳ�CustomerID
					String[] sFlowNoArray = sFlowNo.split("@");
					 bm1 = JBOFactory.getBizObjectManager("jbo.app.BUSINESS_APPLY");
					 tx.join(bm1);//��ͬһ������ִ�У��������ѯ����
					 BizObjectQuery bq1 = bm1
								.createQuery("select CustomerID from O where SerialNo=:SerialNo");
					BizObject bo1=bq1.setParameter("SerialNo", sObjectNo).getSingleResult(false);
					String sCustomerID = bo1.getAttribute("CustomerID").getString();
					if(sCustomerID == null) sCustomerID = "";
					bm2= JBOFactory.getBizObjectManager("jbo.app.CUSTOMER_INFO");
					BizObjectQuery bq2 = bm2
							.createQuery("select CustomerType from O where CustomerID=:CustomerID ");
					 BizObject 	bo2=  bq2.setParameter("CustomerID", sCustomerID).getSingleResult(false);
					String sCustomerType = bo2.getAttribute("CustomerType").getString();
					if(sCustomerType == null) sCustomerType = "";
					//0120 ��С����ҵ,ʹ�����ÿ�������̺�
					
					//FlowNo��ʽ��CreditFlow@SMEStandardFlow����1λ��ʾ������ҵʹ�����̣���2λ��ʾ��С��ҵʹ������
					if(sCustomerType.equals("0120")){
						if(sFlowNoArray.length >= 2){
							sFlowNo = sFlowNoArray[1];
						}else{
							sFlowNo = sFlowNoArray[0];
						}
					}else{
						sFlowNo = sFlowNoArray[0];
					}
					
					//��ȡ��ʼ���׶�
					bm3 = JBOFactory.getBizObjectManager("jbo.sys.FLOW_CATALOG");
				    BizObjectQuery bq3 = bm3
								.createQuery("select InitPhase from O where FlowNo =:FlowNo");
					 BizObject 	bo3=  bq3.setParameter("FlowNo", sFlowNo).getSingleResult();
					sPhaseNo =bo3.getAttribute("InitPhase").getString();
					//���û�г�ʼ�׶α�ţ��׳���ʾ��Ϣ
					if(sPhaseNo==null||sPhaseNo.trim().equals(""))
						throw new Exception("��������"+sFlowNo+"û�г�ʼ���׶α�ţ�");
				}
				
				//�������һ���·�����ҵ���ֻ�������ȣ�����BUSINESS_TYPE��ָ������������,���֮��ȡ���������̱�źͳ�ʼ�׶α�ţ������ǵ��Ѿ�ȡ�õ�Ĭ��ֵ��
				//add by wlu 2009-02-20
				if(sObjectType.equals("CreditApply"))
				{
					String sOccurtype="";
					if(sApplyType==null)sApplyType="";
					if(!sApplyType.equals("CreditLineApply")){
						BizObjectQuery bq4 = bm1
								.createQuery("select Occurtype from O where SerialNo=:SerialNo");
						 BizObject 	bo4=bq4.setParameter("SerialNo", sObjectNo).getSingleResult();
						 sOccurtype=bo4.getAttribute("Occurtype").getString();
						if(sOccurtype==null)sOccurtype="";
					}
					//��������010���·�����ҵ�������������
					if(sApplyType.equals("CreditLineApply")||sOccurtype.equals("010")){
						//��ҵ����в�ѯ�������̱��
						BizObjectQuery bq5 = bm1
								.createQuery("select businesstype from O where serialno=:serialno");
					 BizObject 	bo5=  bq5.setParameter("serialno", sObjectNo).getSingleResult();
					 String sTypeNo = bo5.getAttribute("businesstype").getString();
					bm4 = JBOFactory.getBizObjectManager("jbo.app.BUSINESS_TYPE");
					BizObjectQuery bq6= bm4
							.createQuery("select Attribute9 from O where TypeNo=:TypeNo");
					BizObject 	bo6=bq6.setParameter("TypeNo", sTypeNo).getSingleResult();
					String sFlowNo1=bo6.getAttribute("Attribute9").getString();
					
						if(sFlowNo1 == null) sFlowNo1 = "";
						
						//��������������̱�����ѯ��ʼ�׶α��
						if(!sFlowNo1.equals("")||sFlowNo1.trim().length()>0)			
						{
							sFlowNo = sFlowNo1;
							//��ȡ��ʼ���׶�
							  BizObjectQuery bq7 = bm3
										.createQuery("select InitPhase from O where FlowNo =:FlowNo");
							 BizObject 	bo7=  bq7.setParameter("FlowNo", sFlowNo).getSingleResult();
							sPhaseNo =bo7.getAttribute("InitPhase").getString();
							//���û�г�ʼ�׶α�ţ��׳���ʾ��Ϣ
							if(sPhaseNo==null||sPhaseNo.trim().equals("")) {
								ARE.getLog().error("��������"+sFlowNo1+"û�г�ʼ���׶α��");
								throw new Exception("��������"+sFlowNo1+"û�г�ʼ���׶α�ţ�");
							}
						}
					}
														
				}
						
				//��ȡ���û�����
				bm5 = JBOFactory.getBizObjectManager("jbo.sys.USER_INFO");
				  BizObjectQuery bq8 = bm5
							.createQuery("select UserName from O where UserID =:UserID");
				 BizObject 	bo8=  bq8.setParameter("UserID", sUserID).getSingleResult();
				 sUserName =bo8.getAttribute("UserName").getString();
			    //ȡ�û�������
				bm6= JBOFactory.getBizObjectManager("jbo.sys.ORG_INFO");
				  BizObjectQuery bq9 = bm6
							.createQuery("select OrgName from O where OrgID =:OrgID");
				 BizObject 	bo9=  bq9.setParameter("OrgID", sOrgID).getSingleResult();
				 sOrgName =bo9.getAttribute("OrgName").getString();
		        //ȡ����������
				  BizObjectQuery bq10= bm3
							.createQuery("select FlowName from O where FlowNo =:FlowNo");
				 BizObject 	bo10=  bq10.setParameter("FlowNo", sFlowNo).getSingleResult();
				 sFlowName =bo10.getAttribute("FlowName").getString();
		        //ȡ�ý׶�����
				 bm7= JBOFactory.getBizObjectManager("jbo.sys.FLOW_MODEL");
				  BizObjectQuery bq11 = bm7
							.createQuery("select PhaseName,PhaseType from O where FlowNo =:FlowNo and PhaseNo =:PhaseNo");
				  BizObject 	bo11=  bq11.setParameter("FlowNo", sFlowNo).setParameter("PhaseNo", sPhaseNo).getSingleResult(false);
				  sPhaseName=bo11.getAttribute("PhaseName").getString();
				  sPhaseType=bo11.getAttribute("PhaseType").getString();
			
				
				//��ÿ�ʼ����
			    sBeginTime = StringFunction.getToday()+" "+StringFunction.getNow();	 
			    
			    //����ֵת���ɿ��ַ���
			    if(sObjectType == null) sObjectType = "";
			    if(sObjectNo == null) sObjectNo = "";
			    if(sPhaseType == null) sPhaseType = "";
			    if(sApplyType == null) sApplyType = "";
			    if(sFlowNo == null) sFlowNo = "";
			    if(sFlowName == null) sFlowName = "";
			    if(sPhaseNo == null) sPhaseNo = "";
			    if(sPhaseName == null) sPhaseName = "";
			    if(sUserID == null) sUserID = "";
			    if(sUserName == null) sUserName = "";
			    if(sOrgID == null) sOrgID = "";
			    if(sOrgName == null) sOrgName = "";
			   	    
			    //�����̶����FLOW_OBJECT������һ����Ϣ
			
			    BizObjectManager m=JBOFactory.getFactory().getManager("jbo.sys.FLOW_OBJECT");
			    BizObject me=m.newObject();
			    me.setAttributeValue("ObjectType", sObjectType);
			    me.setAttributeValue("ObjectNo", sObjectNo);
			    me.setAttributeValue("PhaseType", sPhaseType);
			    me.setAttributeValue("ApplyType", sApplyType);
			    me.setAttributeValue("FlowNo", sFlowNo);
			    me.setAttributeValue("FlowName", sFlowName);
			    me.setAttributeValue("PhaseNo", sPhaseNo);
			    me.setAttributeValue("PhaseName", sPhaseName);
			    me.setAttributeValue("OrgID", sOrgID);
			    me.setAttributeValue("OrgName", sOrgName);
			    me.setAttributeValue("UserID", sUserID);
			    me.setAttributeValue("UserName", sUserName);
			    me.setAttributeValue("InputDate", StringFunction.getToday());
			    m.saveObject(me);
			    //�����������FLOW_TASK������һ����Ϣ
			    sSerialNo = DBKeyHelp.getSerialNo("FLOW_TASK","SerialNo","");
			    BizObjectManager m1=JBOFactory.getFactory().getManager("jbo.sys.FLOW_TASK");
			    BizObject me1=m1.newObject();
			    me1.setAttributeValue("SerialNo", sSerialNo);
			    me1.setAttributeValue("ObjectType", sObjectType);
			    me1.setAttributeValue("ObjectNo", sObjectNo);
			    me1.setAttributeValue("PhaseType", sPhaseType);
			    me1.setAttributeValue("ApplyType", sApplyType);
			    me1.setAttributeValue("FlowNo", sFlowNo);
			    me1.setAttributeValue("FlowName", sFlowName);
			    me1.setAttributeValue("PhaseNo", sPhaseNo);
			    me1.setAttributeValue("PhaseName", sPhaseName);
			    me1.setAttributeValue("OrgID", sOrgID);
			    me1.setAttributeValue("UserID", sUserID);
			    me1.setAttributeValue("UserName", sUserName);
			    me1.setAttributeValue("OrgName", sOrgName);
			    me1.setAttributeValue("BegInTime", sBeginTime);
			    m1.saveObject(me1);
			    
			    //ִ�в������
	}
	

}
