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
				//申请类型
				String sApplyType=bo.getAttribute("ApplyType").getString();
				//流程编号
				 String sFlowNo = asPage.getParameter("FlowNo");
				//阶段编号
				 String sPhaseNo = asPage.getParameter("PhaseNo");
				//用户代码
				String sUserID=bo.getAttribute("InputUserID").getString();
				//机构代码
				String sOrgID=bo.getAttribute("InputOrgID").getString();
				//定义变量:用户名称、机构名称、流程名称、阶段名称、阶段类型、开始时间、任务流水号、SQL
				String sUserName = "";
				String sOrgName = "";
				String sFlowName = "";
				String sPhaseName = "";	
				String sPhaseType = "";
				String sBeginTime = "";
				String sSerialNo = "";
				String sSql = "";
				//定义变量：查询结果集
				ASResultSet rs=null;
				SqlObject so;
				// add by fhuang  如果客户类型是中小企业的使用流程模型 SMECreditFlow
				if(sObjectType == null) sObjectType = "";
			
				if(sObjectType.equals("CreditApply")){
					//找出CustomerID
					String[] sFlowNoArray = sFlowNo.split("@");
					 bm1 = JBOFactory.getBizObjectManager("jbo.app.BUSINESS_APPLY");
					 tx.join(bm1);//在同一事物下执行，插入与查询互斥
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
					//0120 中小型企业,使用配置靠后的流程号
					
					//FlowNo格式：CreditFlow@SMEStandardFlow，第1位表示大型企业使用流程，第2位表示中小企业使用流程
					if(sCustomerType.equals("0120")){
						if(sFlowNoArray.length >= 2){
							sFlowNo = sFlowNoArray[1];
						}else{
							sFlowNo = sFlowNoArray[0];
						}
					}else{
						sFlowNo = sFlowNoArray[0];
					}
					
					//获取初始化阶段
					bm3 = JBOFactory.getBizObjectManager("jbo.sys.FLOW_CATALOG");
				    BizObjectQuery bq3 = bm3
								.createQuery("select InitPhase from O where FlowNo =:FlowNo");
					 BizObject 	bo3=  bq3.setParameter("FlowNo", sFlowNo).getSingleResult();
					sPhaseNo =bo3.getAttribute("InitPhase").getString();
					//如果没有初始阶段编号，抛出提示信息
					if(sPhaseNo==null||sPhaseNo.trim().equals(""))
						throw new Exception("审批流程"+sFlowNo+"没有初始化阶段编号！");
				}
				
				//如果申请一笔新发生的业务或只是申请额度，且在BUSINESS_TYPE中指定了审批流程,则从之中取得审批流程编号和初始阶段编号，并覆盖掉已经取得的默认值；
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
					//发生类型010，新发生的业务或申请申请额度
					if(sApplyType.equals("CreditLineApply")||sOccurtype.equals("010")){
						//从业务表中查询审批流程编号
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
						
						//如果存在审批流程编号则查询初始阶段编号
						if(!sFlowNo1.equals("")||sFlowNo1.trim().length()>0)			
						{
							sFlowNo = sFlowNo1;
							//获取初始化阶段
							  BizObjectQuery bq7 = bm3
										.createQuery("select InitPhase from O where FlowNo =:FlowNo");
							 BizObject 	bo7=  bq7.setParameter("FlowNo", sFlowNo).getSingleResult();
							sPhaseNo =bo7.getAttribute("InitPhase").getString();
							//如果没有初始阶段编号，抛出提示信息
							if(sPhaseNo==null||sPhaseNo.trim().equals("")) {
								ARE.getLog().error("审批流程"+sFlowNo1+"没有初始化阶段编号");
								throw new Exception("审批流程"+sFlowNo1+"没有初始化阶段编号！");
							}
						}
					}
														
				}
						
				//获取的用户名称
				bm5 = JBOFactory.getBizObjectManager("jbo.sys.USER_INFO");
				  BizObjectQuery bq8 = bm5
							.createQuery("select UserName from O where UserID =:UserID");
				 BizObject 	bo8=  bq8.setParameter("UserID", sUserID).getSingleResult();
				 sUserName =bo8.getAttribute("UserName").getString();
			    //取得机构名称
				bm6= JBOFactory.getBizObjectManager("jbo.sys.ORG_INFO");
				  BizObjectQuery bq9 = bm6
							.createQuery("select OrgName from O where OrgID =:OrgID");
				 BizObject 	bo9=  bq9.setParameter("OrgID", sOrgID).getSingleResult();
				 sOrgName =bo9.getAttribute("OrgName").getString();
		        //取得流程名称
				  BizObjectQuery bq10= bm3
							.createQuery("select FlowName from O where FlowNo =:FlowNo");
				 BizObject 	bo10=  bq10.setParameter("FlowNo", sFlowNo).getSingleResult();
				 sFlowName =bo10.getAttribute("FlowName").getString();
		        //取得阶段名称
				 bm7= JBOFactory.getBizObjectManager("jbo.sys.FLOW_MODEL");
				  BizObjectQuery bq11 = bm7
							.createQuery("select PhaseName,PhaseType from O where FlowNo =:FlowNo and PhaseNo =:PhaseNo");
				  BizObject 	bo11=  bq11.setParameter("FlowNo", sFlowNo).setParameter("PhaseNo", sPhaseNo).getSingleResult(false);
				  sPhaseName=bo11.getAttribute("PhaseName").getString();
				  sPhaseType=bo11.getAttribute("PhaseType").getString();
			
				
				//获得开始日期
			    sBeginTime = StringFunction.getToday()+" "+StringFunction.getNow();	 
			    
			    //将空值转化成空字符串
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
			   	    
			    //在流程对象表FLOW_OBJECT中新增一笔信息
			
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
			    //在流程任务表FLOW_TASK中新增一笔信息
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
			    
			    //执行插入语句
	}
	

}
