package com.amarsoft.app.lending.bizlets;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import com.amarsoft.amarscript.Any;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.util.AmarScriptHelper;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.app.base.util.StringHelper;
import com.amarsoft.app.als.credit.contract.action.RelevanceBDInfo;
import com.amarsoft.app.als.credit.guaranty.guarantycontract.GetGCContractNo;
import com.amarsoft.app.als.customer.action.CreateCustomerInfo;
import com.amarsoft.app.als.prd.analysis.ProductAnalysisFunctions;
import com.amarsoft.app.workflow.config.FlowConfig;
import com.amarsoft.app.workflow.manager.FlowManager;
import com.amarsoft.app.workflow.util.FlowHelper;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.awe.util.DBKeyHelp;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class InitApplyInfo extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		
		JBOTransaction tx = null;
		try{
			tx = JBOFactory.createJBOTransaction();
			JBOFactory f = JBOFactory.getFactory();
			
			BusinessObject apply = BusinessObject.createBusinessObject();
			for(int i=0;i<this.getAttributes().getKeys().length;i++){
				String key = this.getAttributes().getKeys()[i].toString();
				Object value = this.getAttribute(key);
				apply.setAttributeValue(key, value);
			}
			
			if(apply.getString("ProductID") == null || "".equals(apply.getString("ProductID"))) apply.setAttributeValue("ProductID", apply.getString("BusinessType"));
			
			String applyType = apply.getString("ApplyType");
			String userID = apply.getString("UserID");
			String orgID = apply.getString("OrgID");
			String objectType = "jbo.app.BUSINESS_APPLY";
			String vouchType = "";
			List<String> objects = new ArrayList<String>();
			//客户的处理
			String customerID = apply.getString("CustomerID");
			String customerName = apply.getString("CustomerName");
			if(customerID == null || "".equals(customerID))
			{
				KeyCustomer kc = new KeyCustomer();
				kc.initAttributes(this.getAttributes());
				String customer = (String)kc.run(Sqlca);
				if(customer == null || "".equals(customer))
				{
					String customerType = apply.getString("CustomerType");
					String certType = apply.getString("CertType");
					String certID = apply.getString("CertID");
					String issueCountry = apply.getString("IssueCountry");
					
					CreateCustomerInfo cci = new CreateCustomerInfo();
					cci.setInputParameter("CustomerName", customerName);
					cci.setInputParameter("CustomerType", customerType);
					cci.setInputParameter("CertType", certType);
					cci.setInputParameter("CertID", certID);
					cci.setInputParameter("IssueCountry", issueCountry);
					cci.setInputParameter("InputOrgID", orgID);
					cci.setInputParameter("InputUserID", userID);
					cci.setInputParameter("InputDate", DateHelper.getBusinessDate());
					String result = cci.CreateCustomerInfo(tx);
					customerID = result.split("@")[1];
					
				}else{
					customerID = customer.split("@")[0];
					customerName = customer.split("@")[1];
					CreateCustomerInfo cci = new CreateCustomerInfo();
					cci.SelectCustomerBelong(customerID, orgID, userID, DateHelper.getBusinessDate(),tx);
				}
			}else{
				CreateCustomerInfo cci = new CreateCustomerInfo();
				cci.SelectCustomerBelong(customerID, orgID, userID, DateHelper.getBusinessDate(),tx);
			}
			
			//置最新的客户名称
			BizObjectManager table = JBOFactory.getBizObjectManager("jbo.customer.CUSTOMER_INFO");
			tx.join(table);
			BizObjectQuery q = table.createQuery("CustomerID=:CustomerID").setParameter("CustomerID", customerID);
			BizObject pr = q.getSingleResult(false);
			if(pr!=null)
			{
				customerName = pr.getAttribute("CustomerName").getString();
			}
			apply.setAttributeValue("CustomerName", customerName);
			
			
			//申请信息处理
			BizObjectManager ba = f.getManager("jbo.app.BUSINESS_APPLY");
			BizObjectManager bapplicant = f.getManager("jbo.app.BUSINESS_APPLICANT");
			tx.join(ba);
			tx.join(bapplicant);
			String oldContractSerialNo = "";
			String serialNo = apply.getString("SerialNo");
			BizObject bo = null,applicant = null;
			if(serialNo == null || "".equals(serialNo.trim()))
			{
				bo = ba.newObject();
				if("0020".equals(apply.getString("OccurType")) || "0030".equals(apply.getString("OccurType"))){
					String bdSerialNo = apply.getString("RLSerialNo");
					BizObjectManager bd = JBOFactory.getBizObjectManager("jbo.app.BUSINESS_DUEBILL");
					tx.join(bd);
					BizObjectQuery bdq = bd.createQuery("SerialNo=:SerialNo");
					bdq.setParameter("SerialNo",bdSerialNo);
					BizObject nbdq = bdq.getSingleResult(false);
					oldContractSerialNo = nbdq.getAttribute("CONTRACTSERIALNO").getString();
					
					BizObjectManager bc = JBOFactory.getBizObjectManager("jbo.app.BUSINESS_CONTRACT");
					tx.join(bc);
					BizObjectQuery bcq = bc.createQuery("SerialNo=:SerialNo");
					bcq.setParameter("SerialNo",oldContractSerialNo);
					BizObject nbcq = bcq.getSingleResult(false);
					bo.setAttributesValue(nbcq);
					bo.setAttributeValue("SerialNo", null);
					bo.setAttributeValue("MATURITYDATE", null);
					bo.setAttributeValue("FIRSTDRAWDOWNDATE", null);
					if(nbcq!=null)
					{
						if("888".equals(bo.getAttribute("BusinessType").getString()) || "502".equals(bo.getAttribute("BusinessType").getString())
								|| "666".equals(bo.getAttribute("BusinessType").getString()) || "500".equals(bo.getAttribute("BusinessType").getString())
								|| "555".equals(bo.getAttribute("BusinessType").getString()) || "999".equals(bo.getAttribute("BusinessType").getString()))
						{
							apply.setAttributeValue("CLSerialNo", oldContractSerialNo);
						}
					}
				}
				bo.setAttributeValue("OccurDate", DateHelper.getBusinessDate());
				bo.setAttributeValue("CustomerID", customerID);
				bo.setAttributeValue("CustomerName", customerName);
				bo.setAttributeValue("OccurType", apply.getString("OccurType"));
				if("Apply03".equals(applyType))//额度申请
				{
					bo.setAttributeValue("BusinessType", "555");
					bo.setAttributeValue("ProductID", "555");
				}
				else
				{
					bo.setAttributeValue("BusinessType", apply.getString("BusinessType"));
					bo.setAttributeValue("ProductID", apply.getString("ProductID"));
				}
				
				bo.setAttributeValue("BusinessCurrency", apply.getString("BusinessCurrency"));
				bo.setAttributeValue("BusinessSum", apply.getDouble("BusinessSum"));
				bo.setAttributeValue("BusinessTerm", apply.getInt("BusinessTerm"));
				bo.setAttributeValue("BusinessTermDay", apply.getInt("BusinessTermDay"));
				bo.setAttributeValue("BusinessTermUnit", apply.getString("BusinessTermUnit"));
				bo.setAttributeValue("BusinessPriority", apply.getString("BusinessPriority"));
				bo.setAttributeValue("NonstdIndicator", apply.getString("NonstdIndicator"));
				bo.setAttributeValue("AccountingOrgID", apply.getString("AccountingOrgID"));
				bo.setAttributeValue("OperateUserID", userID);
				bo.setAttributeValue("OperateOrgID", orgID);
				bo.setAttributeValue("OperateDate", DateHelper.getBusinessDate());
				bo.setAttributeValue("InputUserID", userID);
				bo.setAttributeValue("InputOrgID", orgID);
				bo.setAttributeValue("InputDate", DateHelper.getBusinessDate());
				bo.setAttributeValue("UpdateDate", DateHelper.getBusinessDate());
				bo.setAttributeValue("ApproveStatus", "01");
				//小微信贷，更新客户基本信息中的小微信贷表示为1
				
				String productIDSM = bo.getAttribute("ProductID").getString();
				BizObjectManager prlbom = JBOFactory.getBizObjectManager("jbo.prd.PRD_PRODUCT_LIBRARY");
				tx.join(prlbom);
				BizObjectQuery prlbq = prlbom.createQuery("ProductID=:ProductID");			
				prlbq.setParameter("ProductID", productIDSM);
				BizObject prl = prlbq.getSingleResult(false);
				
				BizObjectManager cibom = JBOFactory.getBizObjectManager("jbo.customer.CUSTOMER_INFO");
				tx.join(cibom);
				BizObjectQuery cibq = cibom.createQuery("CustomerId=:CustomerId ");	
				cibq.setParameter("CustomerId", customerID);	
				BizObject ci = cibq.getSingleResult(true);
				if(ci != null){
					if ("02".equals(prl.getAttribute("PRODUCTTYPE3").getString())){
						ci.setAttributeValue("SMEMONOPOLYFLAG", "1");
						cibom.saveObject(ci);
					}else{
						ci.setAttributeValue("ISCONSUMECREDIT", "1");
						cibom.saveObject(ci);
					}	
				}
				
				
				//生成合同编号
				String contractArtificialNo = "";
				String duebillSerialNo = "";
				String guarantyType = "";
				String CLSerialNo = apply.getString("CLSerialNo");
				if(CLSerialNo != null && !"".equals(CLSerialNo) && !"0030".equals(bo.getAttribute("OccurType").getString()) && !"0020".equals(bo.getAttribute("OccurType").getString()))
				{
					BizObjectManager bcm = f.getManager("jbo.app.BUSINESS_CONTRACT");
					tx.join(bcm);
					
					BizObjectQuery bcq =  bcm.createQuery("SerialNo=:SerialNo");
					bcq.setParameter("SerialNo", CLSerialNo);
					BizObject bc = bcq.getSingleResult(false);
					contractArtificialNo = bc.getAttribute("ContractArtificialNo").getString();
					vouchType = bc.getAttribute("VouchType").getString();
					guarantyType = bc.getAttribute("GuarantyType").getString();
					if("888".equals(apply.getString("BusinessType")) || "502".equals(apply.getString("BusinessType"))
							|| "666".equals(apply.getString("BusinessType")) || "500".equals(apply.getString("BusinessType")))
					{
						String businessFlag = "5";
						contractArtificialNo = DBKeyHelp.getSerialNo("BUSINESS_CONTRACT", "ContractArtificialNo", apply.getString("AccountingOrgID")+"yyyy"+businessFlag, "00000", new Date(), Sqlca);
					}
					duebillSerialNo = DBKeyHelp.getSerialNo("BUSINESS_DUEBILL", "SERIALNO", contractArtificialNo, "00", new Date());
				}
				else
				{
					String businessFlag = "1";
					//轻松智业卡授信额度、融资易转账额度、消贷易授信额度、融资易刷卡额度
					if("888".equals(bo.getAttribute("BusinessType").getString()) || "502".equals(bo.getAttribute("BusinessType").getString())
						|| "666".equals(bo.getAttribute("BusinessType").getString()) || "500".equals(bo.getAttribute("BusinessType").getString()))
					{
						businessFlag = "5";
					}
					
					contractArtificialNo = DBKeyHelp.getSerialNo("BUSINESS_CONTRACT", "ContractArtificialNo", apply.getString("AccountingOrgID")+"yyyy"+businessFlag, "00000", new Date(), Sqlca);
					if(!"555".equals(bo.getAttribute("BusinessType").getString()))
						duebillSerialNo = DBKeyHelp.getSerialNo("BUSINESS_DUEBILL", "SERIALNO", contractArtificialNo, "00", new Date());
					
				}
				
				//是否循环标示
				if("888".equals(bo.getAttribute("BusinessType").getString()) || "502".equals(bo.getAttribute("BusinessType").getString())
						|| "666".equals(bo.getAttribute("BusinessType").getString()) || "500".equals(bo.getAttribute("BusinessType").getString())
						|| "555".equals(bo.getAttribute("BusinessType").getString()))
				{
					bo.setAttributeValue("REVOLVEFLAG", "1");
				}
				else
				{
					bo.setAttributeValue("REVOLVEFLAG", "2");
				}
				
				bo.setAttributeValue("VouchType", vouchType);
				bo.setAttributeValue("GuarantyType", guarantyType);
				bo.setAttributeValue("ContractArtificialNo", contractArtificialNo);
				bo.setAttributeValue("DuebillSerialNo", duebillSerialNo);
				ba.saveObject(bo);
				serialNo = bo.getAttribute("SerialNo").getString();
				
				saveRelativePrj(tx,f,apply,serialNo);//添加项目关联关系
				
				if("0020".equals(apply.getString("OccurType")) || "0030".equals(apply.getString("OccurType"))){
					RelevanceBDInfo aaa = new RelevanceBDInfo();
					aaa.setContractSerialNo(oldContractSerialNo);
					aaa.setSerialNo(serialNo);
					aaa.copyOldInfo(tx);
				}
				applicant = bapplicant.newObject();
				applicant.setAttributeValue("ObjectType", objectType);
				applicant.setAttributeValue("ObjectNo", serialNo);
				applicant.setAttributeValue("ApplicantID", customerID);
				applicant.setAttributeValue("ApplicantName", customerName);
				applicant.setAttributeValue("InputUserID", userID);
				applicant.setAttributeValue("InputOrgID", orgID);
				applicant.setAttributeValue("InputDate", DateHelper.getBusinessDate());
				applicant.setAttributeValue("UpdateDate", DateHelper.getBusinessDate());
				applicant.setAttributeValue("ApplicantType", "01");//主申请人
				applicant.setAttributeValue("Status", "01");//主申请人状态
				bapplicant.saveObject(applicant);
			}
			else
			{
				BizObjectQuery baq =  ba.createQuery("SerialNo=:SerialNo");
				baq.setParameter("SerialNo", serialNo);
				List<BizObject> bos = baq.getResultList(true);
				if(bos == null || bos.isEmpty()) throw new Exception("未找到申请信息，请检查！");
				bo = bos.get(0);
				bo.setAttributeValue("CustomerID", customerID);
				bo.setAttributeValue("CustomerName", customerName);
				bo.setAttributeValue("OccurType", apply.getString("OccurType"));
				bo.setAttributeValue("BusinessType", "555");
				bo.setAttributeValue("ProductID", "555");
				bo.setAttributeValue("BusinessCurrency", apply.getString("BusinessCurrency"));
				bo.setAttributeValue("BusinessSum", apply.getDouble("BusinessSum"));
				bo.setAttributeValue("BusinessTerm", apply.getInt("BusinessTerm"));
				bo.setAttributeValue("BusinessTermDay", apply.getInt("BusinessTermDay"));
				bo.setAttributeValue("BusinessTermUnit", apply.getString("BusinessTermUnit"));
				bo.setAttributeValue("BusinessPriority", apply.getString("BusinessPriority"));
				bo.setAttributeValue("NonstdIndicator", apply.getString("NonstdIndicator"));
				ba.saveObject(bo);
				
				baq = bapplicant.createQuery("ObjectType=:ObjectType and ObjectNo=:ObjectNo and ApplicantType='01' ");
				baq.setParameter("ObjectNo", serialNo);
				baq.setParameter("ObjectType", objectType);
				
				List<BizObject> applicants = baq.getResultList(true);
				if(applicants == null || applicants.isEmpty()) throw new Exception("未找到主申请人信息，请检查！");
				applicant = applicants.get(0);
				applicant.setAttributeValue("ApplicantID", customerID);
				applicant.setAttributeValue("ApplicantName", customerName);
				applicant.setAttributeValue("InputUserID", userID);
				applicant.setAttributeValue("InputOrgID", orgID);
				applicant.setAttributeValue("InputDate", DateHelper.getBusinessDate());
				applicant.setAttributeValue("UpdateDate", DateHelper.getBusinessDate());
				applicant.setAttributeValue("ApplicantType", "01");//主申请人
				applicant.setAttributeValue("Status", "01");//主申请人状态
				bapplicant.saveObject(applicant);
			}
			objects.add(serialNo);
			
			BizObjectManager ar = f.getManager("jbo.app.APPLY_RELATIVE");
			tx.join(ar);
			
			
			String relaSerialNo ="";
			//业务打包申请信息 待实现
			if("1".equals(apply.getString("RelativeFlag")))
			{
				BizObject deBo = ba.newObject();
				deBo.setAttributesValue(bo);
				deBo.setAttributeValue("SerialNo", null);
				deBo.setAttributeValue("BusinessType", apply.getString("BusinessType"));
				deBo.setAttributeValue("ProductID", apply.getString("ProductID"));
				deBo.setAttributeValue("BusinessSum", "0");
				
				String businessFlag = "1";
				String contractArtificialNo= "";
				//轻松智业卡授信额度、融资易转账额度、消贷易授信额度、融资易刷卡额度
				if("888".equals(apply.getString("BusinessType")) || "502".equals(apply.getString("BusinessType"))
					|| "666".equals(apply.getString("BusinessType")) || "500".equals(apply.getString("BusinessType")))
				{
					businessFlag = "5";
					contractArtificialNo = DBKeyHelp.getSerialNo("BUSINESS_CONTRACT", "ContractArtificialNo", apply.getString("AccountingOrgID")+"yyyy"+businessFlag, "00000", new Date(), Sqlca);
					deBo.setAttributeValue("REVOLVEFLAG", "1");
				}
				else
				{
					contractArtificialNo = bo.getAttribute("ContractArtificialNo").getString();
					deBo.setAttributeValue("REVOLVEFLAG", "2");
				}
				
				
				
				String duebillSerialNo = DBKeyHelp.getSerialNo("BUSINESS_DUEBILL", "SERIALNO", contractArtificialNo, "00", new Date());
				
				deBo.setAttributeValue("ContractArtificialNo", contractArtificialNo);
				deBo.setAttributeValue("DuebillSerialNo", duebillSerialNo);
				ba.saveObject(deBo);
				relaSerialNo = deBo.getAttribute("SerialNo").getString();
				//objects.add(deBo.getAttribute("SerialNo").getString());
				if("Apply03".equals(applyType))
				{
					BizObject boar = ar.newObject();
					boar.setAttributeValue("ApplySerialNo", serialNo);
					boar.setAttributeValue("ObjectType", "jbo.app.BUSINESS_APPLY");
					boar.setAttributeValue("ObjectNo",deBo.getAttribute("SerialNo").getString());
					boar.setAttributeValue("RelativeType","04");
					ar.saveObject(boar);
					
					boar = ar.newObject();
					boar.setAttributeValue("ApplySerialNo", deBo.getAttribute("SerialNo").getString());
					boar.setAttributeValue("ObjectType", "jbo.app.BUSINESS_APPLY");
					boar.setAttributeValue("ObjectNo",serialNo);
					boar.setAttributeValue("RelativeType","06");
					ar.saveObject(boar);
				}
			}
			
			
			if("1".equals(apply.getString("FundFlag")))
			{
				BizObject deBo = ba.newObject();
				deBo.setAttributesValue(bo);
				deBo.setAttributeValue("SerialNo", null);
				deBo.setAttributeValue("BusinessType", apply.getString("FundBusinessType"));
				deBo.setAttributeValue("ProductID", ((apply.getString("FundProductID")== null || "".equals(apply.getString("FundProductID"))) ? apply.getString("FundBusinessType") : apply.getString("FundProductID")));
				deBo.setAttributeValue("BusinessSum", "0");
				
				String businessFlag = "1";
				String contractArtificialNo= DBKeyHelp.getSerialNo("BUSINESS_CONTRACT", "ContractArtificialNo", apply.getString("AccountingOrgID")+"yyyy"+businessFlag, "00000", new Date(), Sqlca);
				
				
				String duebillSerialNo = DBKeyHelp.getSerialNo("BUSINESS_DUEBILL", "SERIALNO", contractArtificialNo, "00", new Date());
				
				deBo.setAttributeValue("ContractArtificialNo", contractArtificialNo);
				deBo.setAttributeValue("DuebillSerialNo", duebillSerialNo);
				ba.saveObject(deBo);
				
				BizObject boar = ar.newObject();
				boar.setAttributeValue("ApplySerialNo", serialNo);
				boar.setAttributeValue("ObjectType", "jbo.app.BUSINESS_APPLY");
				boar.setAttributeValue("ObjectNo",deBo.getAttribute("SerialNo").getString());
				boar.setAttributeValue("RelativeType","07");
				ar.saveObject(boar);
			}
			
			
			//关联额度处理
			String CLSerialNo = apply.getString("CLSerialNo");
			if(CLSerialNo != null && !"".equals(CLSerialNo) && !"0030".equals(bo.getAttribute("OccurType").getString()) && !"0020".equals(bo.getAttribute("OccurType").getString()))
			{
				BizObjectQuery arq =  ar.createQuery("ApplySerialNo=:SerialNo and RelativeType='06'");
				arq.setParameter("SerialNo", serialNo);
				List<BizObject> ls = arq.getResultList(false);
				for(BizObject l:ls)
					ar.deleteObject(l);
				BizObject boar = ar.newObject();
				boar.setAttributeValue("ApplySerialNo", serialNo);
				boar.setAttributeValue("ObjectType", "jbo.app.BUSINESS_CONTRACT");
				boar.setAttributeValue("ObjectNo",CLSerialNo);
				boar.setAttributeValue("RelativeType","06");
				ar.saveObject(boar);
				
				BizObjectManager crm = f.getManager("jbo.app.CONTRACT_RELATIVE");
				tx.join(crm);
				BizObjectQuery crq = crm.createQuery("ContractSerialNo=:ContractSerialNo and ObjectType=:ObjectType and RelativeType=:RelativeType ");
				crq.setParameter("ContractSerialNo", CLSerialNo);
				crq.setParameter("ObjectType", "jbo.guaranty.GUARANTY_CONTRACT");
				crq.setParameter("RelativeType", "05");
				List<BizObject> crs = crq.getResultList(false);
				
				for(BizObject cr:crs)
				{
					BizObject crar = ar.newObject();
					crar.setAttributesValue(cr);
					crar.setAttributeValue("SerialNo", null);
					crar.setAttributeValue("ApplySerialNo", serialNo);
					ar.saveObject(crar);
				}
			}
			
			//关联借据处理（借新还旧、重组、续作）
			String RLSerialNo = apply.getString("RLSerialNo");
			if(RLSerialNo != null && !"".equals(RLSerialNo))
			{
				BizObjectQuery arq =  ar.createQuery("ApplySerialNo=:SerialNo and RelativeType='01'");
				arq.setParameter("SerialNo", serialNo);
				List<BizObject> ls = arq.getResultList(false);
				for(BizObject l:ls)
					ar.deleteObject(l);
				BizObject boar = ar.newObject();
				boar.setAttributeValue("ApplySerialNo", serialNo);
				boar.setAttributeValue("ObjectType", "jbo.app.BUSINESS_DUEBILL");
				boar.setAttributeValue("ObjectNo",RLSerialNo);
				boar.setAttributeValue("RelativeType","01");
				ar.saveObject(boar);
			}
			
			//额度新增关联信息处理
			if("Apply03".equals(applyType) || "666".equals(apply.getString("BusinessType")) 
					|| "502".equals(apply.getString("BusinessType")) || "500".equals(apply.getString("BusinessType")))
			{
				//额度信息
				BizObjectManager clbm = f.getManager("jbo.cl.CL_INFO");
				tx.join(clbm);
				BizObject clbo = clbm.newObject();
				clbo.setAttributeValue("ObjectType",objectType);
				clbo.setAttributeValue("ObjectNo",serialNo);
				clbo.setAttributeValue("Status", "10");//状态未生效
				clbo.setAttributeValue("REVOLVINGFLAG", "1");//循环标示
				clbm.saveObject(clbo);
				
				//是否申请消贷易
				if("666".equals(apply.getString("BusinessType")) && relaSerialNo != null && !"".equals(relaSerialNo))
				{
					//额度信息
					BizObject clbo1 = clbm.newObject();
					clbo1.setAttributeValue("ObjectType",objectType);
					clbo1.setAttributeValue("ObjectNo",relaSerialNo);
					clbo1.setAttributeValue("PARENTSERIALNO",clbo.getAttribute("SerialNo").getString());
					clbo1.setAttributeValue("ROOTSERIALNO",clbo.getAttribute("SerialNo").getString());
					clbo1.setAttributeValue("Status", "10");//状态未生效
					clbo1.setAttributeValue("REVOLVINGFLAG", "1");//循环标示
					clbm.saveObject(clbo1);
				
				}
			}
			
			
			
			String groupSerialNo = apply.getString("GroupSerialNo");
			if(groupSerialNo != null && !"".equals(groupSerialNo))
			{
				BizObjectQuery arq =  ar.createQuery("ObjectType=:ObjectType and ObjectNo=:ObjectNo and RelativeType='08'");
				arq.setParameter("ObjectType", "jbo.customer.CUSTOMER_LIST");
				arq.setParameter("ObjectNo", groupSerialNo);
				List<BizObject> ls = arq.getResultList(false);
				
				//联贷联保保证处理*********************start************************
				if("051".equals(apply.getString("ProductID"))){
					BizObjectManager gcm = f.getManager("jbo.guaranty.GUARANTY_CONTRACT");
					tx.join(gcm);
					if(ls == null || (ls != null && ls.size() == 0)){//该联保体第一个申请
						BizObject gcbo = gcm.newObject();
						gcbo.setAttributeValue("ContractType", "010");
						gcbo.setAttributeValue("GuarantyType", "01030");//联贷联保保证
						gcbo.setAttributeValue("ContractStatus", "01");//待生效
						gcbo.setAttributeValue("ContractNo", GetGCContractNo.getCeilingGCContractNo(orgID));
						gcbo.setAttributeValue("GuarantorID", customerID);
						gcbo.setAttributeValue("GuarantorName", customerName);
						gcbo.setAttributeValue("GuarantyCurrency", "CNY");
						gcbo.setAttributeValue("GuarantyValue", apply.getDouble("BusinessSum"));//担保金额
						gcbo.setAttributeValue("InputOrgID", orgID);
						gcbo.setAttributeValue("InputUserID", userID);
						gcbo.setAttributeValue("InputDate", DateHelper.getBusinessDate());
						gcbo.setAttributeValue("GuaranteeType", "1");//多人联保
						gcm.saveObject(gcbo);
						
						BizObject gcar = ar.newObject();
						gcar.setAttributeValue("ApplySerialNo", serialNo);
						gcar.setAttributeValue("ObjectType", "jbo.guaranty.GUARANTY_CONTRACT");
						gcar.setAttributeValue("ObjectNo",gcbo.getAttribute("SerialNo").getString());
						gcar.setAttributeValue("RelativeType","05");
						gcar.setAttributeValue("RelativeAmount",apply.getDouble("BusinessSum"));
						ar.saveObject(gcar);
						
					}
					else{//该联保体已经存在申请
						String applySerialNoTemp = ls.get(0).getAttribute("ApplySerialNo").getString();
						BizObjectQuery arq1 =  ar.createQuery("ApplySerialNo=:ApplySerialNo and ObjectType='jbo.guaranty.GUARANTY_CONTRACT' and RelativeType='05'");
						arq1.setParameter("ApplySerialNo", applySerialNoTemp);
						List<BizObject> arList = arq1.getResultList(false);
						String ldlbGCNo = "";//联贷联保保证担保合同流水号
						for(BizObject o:arList){
							String gcNo = o.getAttribute("ObjectNo").getString();
							BizObjectQuery gcq =  gcm.createQuery("SerialNo=:SerialNo");
							gcq.setParameter("SerialNo", gcNo);
							BizObject gc = gcq.getSingleResult(true);
							String guarantyType = gc.getAttribute("GuarantyType").getString();
							if("01030".equals(guarantyType)){
								ldlbGCNo = gcNo;
								gc.setAttributeValue("GuarantorID", gc.getAttribute("GuarantorID")+"@"+customerID);//function里配置类型为Java的Param时此处的“,”会导致参数个数误判，从而导致java类找不到，改成@分隔
								gc.setAttributeValue("GuarantorName", gc.getAttribute("GuarantorName")+","+customerName);
								gc.setAttributeValue("GuarantyValue", gc.getAttribute("GuarantyValue").getDouble()+apply.getDouble("BusinessSum"));
								gcm.saveObject(gc);
								
								BizObject newgcar = ar.newObject();
								newgcar.setAttributeValue("ApplySerialNo", serialNo);
								newgcar.setAttributeValue("ObjectType", "jbo.guaranty.GUARANTY_CONTRACT");
								newgcar.setAttributeValue("ObjectNo",ldlbGCNo);
								newgcar.setAttributeValue("RelativeType","05");
								newgcar.setAttributeValue("RelativeAmount",apply.getDouble("BusinessSum"));
								ar.saveObject(newgcar);
								
								break;
							}
						}
						
						
					}
				}
				//联贷联保保证处理************************end************************
				
				for(BizObject l:ls)
				{
					objects.add(l.getAttribute("ApplySerialNo").getString());
				}
				
				arq =  ar.createQuery("ApplySerialNo=:SerialNo and RelativeType='08'");
				arq.setParameter("SerialNo", serialNo);
				ls = arq.getResultList(false);
				for(BizObject l:ls)
					ar.deleteObject(l);
				BizObject boar = ar.newObject();
				boar.setAttributeValue("ApplySerialNo", serialNo);
				boar.setAttributeValue("ObjectType", "jbo.customer.CUSTOMER_LIST");
				boar.setAttributeValue("ObjectNo",groupSerialNo);
				boar.setAttributeValue("RelativeType","08");
				ar.saveObject(boar);
			}
			
			String productID = apply.getString("ProductID");
			if(productID == null || "".equals(productID)) productID = bo.getAttribute("BusinessType").getString();
			if(productID == null || "".equals(productID)) productID = "555";
			//业务资料定义
			String docs = ProductAnalysisFunctions.getComponentMandatoryValue(BusinessObject.convertFromBizObject(bo), "PRD04-01", "BusinessDocs", "0010", "01");
		
			if(docs != null && !"".equals(docs)){
				BizObjectManager dfi = f.getManager("jbo.doc.DOC_FILE_INFO");
				tx.join(dfi);
				BizObjectQuery dfiq = dfi.createQuery("select count(*) as v.cnt from O where ObjectType=:ObjectType and ObjectNo=:ObjectNo and FILEFORMAT = '03'");
				dfiq.setParameter("OBJECTTYPE", "contract");
				dfiq.setParameter("OBJECTNO", bo.getAttribute("ContractArtificialNo").getString());
				BizObject dfibo = dfiq.getSingleResult(false);
				
				if(dfibo.getAttribute("cnt").getInt() == 0)
				{
					String[] docArray = docs.split(",");
					for(String docID:docArray){
						BizObject dfiBo = dfi.newObject();
						dfiBo.setAttributeValue("FILEID", docID);
						dfiBo.setAttributeValue("OBJECTTYPE", "contract");
						dfiBo.setAttributeValue("OBJECTNO", bo.getAttribute("ContractArtificialNo").getString());
						dfiBo.setAttributeValue("IMAGEDATE", DateHelper.getBusinessDate());
						dfiBo.setAttributeValue("STATUS", "02");
						dfiBo.setAttributeValue("FILEFORMAT", "03");
						dfi.saveObject(dfiBo);
					}
				}
			}
			//业务流程定义
			String flowNo =  ProductAnalysisFunctions.getComponentDefaultValue(BusinessObject.convertFromBizObject(bo), "PRD04-02", "CreditApproveFlowNo","0010", "01");
			if(flowNo == null || "".equals(flowNo))   throw new Exception("未取到项下支用业务流程定义，请联系系统管理员。");
			
			//如果是999额度项下业务才使用宽授信流程
			if(CLSerialNo != null && !"".equals(CLSerialNo))
			{
				BizObjectManager bcm = JBOFactory.getBizObjectManager("jbo.app.BUSINESS_CONTRACT");
				tx.join(bcm);
				BizObjectQuery bcq = bcm.createQuery("SerialNo=:SerialNo");
				bcq.setParameter("SerialNo",CLSerialNo);
				BizObject bc = bcq.getSingleResult(false);
				if(bc != null && "999".equals(bc.getAttribute("BusinessType").getString()))
				{
					flowNo =  ProductAnalysisFunctions.getComponentDefaultValue(BusinessObject.convertFromBizObject(bo), "PRD04-02", "SubCreditApproveFlowNo","0010", "01");
					if(flowNo == null || "".equals(flowNo)) throw new Exception("未取到项下支用业务流程定义，请联系系统管理员。");
				}
			}
			
			String flowVersion = FlowConfig.getFlowDefaultVersion(flowNo);
			BusinessObjectManager bomanager = BusinessObjectManager.createBusinessObjectManager(tx);
			FlowManager fm = FlowManager.getFlowManager(bomanager);
			List<BusinessObject> bos = bomanager.loadBusinessObjects("jbo.app.BUSINESS_APPLY", "SerialNo in(:SerialNo)", "SerialNo",objects.toArray(new String[0]));
			String result = fm.createInstance(objectType, bos, flowNo, userID, orgID, apply);
			//流程是否启动不影响整个数据处理
			String instanceID = result.split("@")[0];
			String phaseNo = result.split("@")[1];
			String taskSerialNo = result.split("@")[2];
			
			 
			//functionID 处理
			String functionID = FlowConfig.getFlowPhase(flowNo, flowVersion, phaseNo).getString("FunctionID");
			if(functionID != null && !"".equals(functionID) && (functionID.indexOf("'") >-1 || functionID.indexOf("\"") > -1 || functionID.indexOf("(") > -1))
			{
				BusinessObjectManager bommanager = BusinessObjectManager.createBusinessObjectManager(tx);
				BusinessObject boo = bommanager.keyLoadBusinessObject("jbo.app.BUSINESS_APPLY", serialNo);
				boo.setAttributeValue("ImageFlag", FlowHelper.getImageFlag(boo));
				functionID = StringHelper.replaceString(functionID,boo);
				functionID = StringHelper.replaceToSpace(functionID);
				Any a=AmarScriptHelper.getScriptValue(functionID, BusinessObjectManager.createBusinessObjectManager(tx));
				functionID = a.toStringValue();
			}
			tx.commit();
			
			return "true@"+serialNo +"@"+customerID+"@"+functionID+"@"+instanceID+"@"+taskSerialNo+"@"+phaseNo+"@保存成功！";
		}catch(Exception ex){
			if(tx != null) tx.rollback();
			ex.printStackTrace();
			return "error@"+ex.getMessage();
		}
	}
	
	private String saveRelativePrj(JBOTransaction tx,JBOFactory f,BusinessObject apply,String baSerialNo) throws JBOException{
		BizObjectManager bom = f.getBizObjectManager("jbo.prj.PRJ_RELATIVE",tx);
		BizObject bo = bom.newObject();
		bo.setAttributeValue("PROJECTSERIALNO", apply.getString("ProjectSerialNo"));
		bo.setAttributeValue("OBJECTNO", baSerialNo);
		bo.setAttributeValue("OBJECTTYPE", "jbo.app.BUSINESS_APPLY");
		bo.setAttributeValue("RELATIVETYPE", "01");
		bom.saveObject(bo);
		return "true";
	}
}
