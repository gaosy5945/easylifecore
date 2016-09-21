package com.amarsoft.app.als.guaranty.model;

import java.sql.SQLException;
import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.are.util.json.JSONObject;
import com.amarsoft.app.als.credit.apply.action.CollateralTemplate;


/**
 * @author t-zhangq2
 * ԭGuarantyContractAction.java���ƶ�����Ϊ����
 * ���
 */
public class GuarantyContractAction2 {
	private JSONObject inputParameter;
	
	private BusinessObjectManager businessObjectManager;
	
	public void setInputParameter(JSONObject inputParameter) {
		this.inputParameter = inputParameter;
	}
	
	private JBOTransaction tx;
	
	public void setTx(JBOTransaction tx) {
		this.tx = tx;
	}
	
	public void setBusinessObjectManager(BusinessObjectManager businessObjectManager) {
		this.businessObjectManager = businessObjectManager;
		this.tx = businessObjectManager.getTx();
	}
	
	private BusinessObjectManager getBusinessObjectManager() throws JBOException, SQLException{
		if(businessObjectManager==null)
			businessObjectManager = BusinessObjectManager.createBusinessObjectManager(tx);
		return businessObjectManager;
	}

	//���ݵ�����ͬ�Ż�ȡҵ��Ʒ�֣���߶��ʱ���ؿ�
	public String getProduct(JBOTransaction tx) throws Exception{
		this.tx=tx;
		String objectType = (String)inputParameter.getValue("ObjectType");
		if(objectType==null) objectType="";
		String objectNo = (String)inputParameter.getValue("ObjectNo");
		if(objectNo==null) objectNo="";
		return this.getProduct(objectType,objectNo);
	}
	
	public String getProduct(String objectType,String objectNo) throws Exception{
		if("".equals(objectType) || "".equals(objectNo))//��ҵ����Ϣ�������ز�ƷƷ����Ϣ
			return "false";
		BusinessObjectManager bomanager = this.getBusinessObjectManager();
		BusinessObject businessObject = bomanager.keyLoadBusinessObject(objectType, objectNo);
		if(businessObject == null) throw new Exception("����"+objectType+",���"+objectNo+"δ���ص�");
		String productID = businessObject.getString("ProductID");
		if(productID == null) productID="";
		String businessType = businessObject.getString("BusinessType");
		if(businessType == null) businessType="";
		
		return "true@"+productID+"@"+businessType;
	}
	
	//���ñ���߶����ͬ�Ƿ��Ѿ�������
	public String checkCeilingGC(JBOTransaction tx) throws Exception{
		this.tx = tx;
		String gcSerialNo = (String)inputParameter.getValue("GCSerialNo");
		String objectNo = (String)inputParameter.getValue("ApplySerialNo");
		return this.checkCeilingGC(gcSerialNo,objectNo);
	}
	
	public String checkCeilingGC(String gcSerialNo,String applySerialNo) throws Exception{
		BusinessObjectManager bomanager = this.getBusinessObjectManager();
		List<BusinessObject>arList = bomanager.loadBusinessObjects("jbo.app.APPLY_RELATIVE", "ObjectType='jbo.guaranty.GUARANTY_CONTRACT'"
				+ " and ObjectNo=:ObjectNo and ApplySerialNo=:ApplySerialNo", "ObjectNo",gcSerialNo,"ApplySerialNo",applySerialNo);
		if(arList != null && arList.size() != 0)
			return "false";
		else
			return "true";
	}
	
	//��鵣�������Ƿ񳬹�Ҫ��
	public String checkGuarantyPercent(JBOTransaction tx) throws Exception{
		this.tx = tx;
		String assetType = (String)inputParameter.getValue("AssetType");
		String guarantyPercent = (String)inputParameter.getValue("GuarantyPercent");
		
		return this.checkGuarantyPercent(assetType,Double.valueOf(guarantyPercent));
	}
	
	public String checkGuarantyPercent(String assetType,Double guarantyPercent) throws Exception{
		CollateralTemplate ct = new CollateralTemplate();
		double perct = ct.getGuarantyPercent(assetType);
		if(perct == 0){
			if(guarantyPercent.doubleValue() > 9999)
				return "false";
			else
				return "true";
		}
		if(guarantyPercent.doubleValue()/100 > perct){
			return "false";
		}
		return "true";
	}
	
	//���ñ���߶����ͬ�Ƿ�����ʹ��
	public String isCeilingGCInUse(JBOTransaction tx) throws Exception{
		this.tx = tx;
		String gcSerialNo = (String)inputParameter.getValue("GCSerialNo");
		return this.isCeilingGCInUse(gcSerialNo);
	}
	
	public String isCeilingGCInUse(String gcSerialNo) throws Exception{
		BusinessObjectManager bomanager = this.getBusinessObjectManager();
		List<BusinessObject>arList = bomanager.loadBusinessObjects("jbo.app.APPLY_RELATIVE", "ObjectType='jbo.guaranty.GUARANTY_CONTRACT'"
				+ " and ObjectNo=:ObjectNo and RelativeType='05'", "ObjectNo",gcSerialNo);
		for(BusinessObject ar:arList){
			String applyNo = ar.getString("ApplySerialNo");
			BusinessObject apply = bomanager.keyLoadBusinessObject("jbo.app.BUSINESS_APPLY", applyNo);
			String status = apply.getString("ApproveStatus");
			if("01".equals(status) || "02".equals(status) || "06".equals(status)){
				return "true";//���ڱ�ʹ��
			}
		}
		
		List<BusinessObject>crList = bomanager.loadBusinessObjects("jbo.app.CONTRACT_RELATIVE", "ObjectType='jbo.guaranty.GUARANTY_CONTRACT'"
				+ " and ObjectNo=:ObjectNo and RelativeType='05'", "ObjectNo",gcSerialNo);
		for(BusinessObject cr:crList){
			String contractNo = cr.getString("ContractSerialNo");
			BusinessObject contract = bomanager.keyLoadBusinessObject("jbo.app.BUSINESS_CONTRACT", contractNo);
			String status = contract.getString("ContractStatus");
			if("01".equals(status) || "02".equals(status) || "03".equals(status)){
				return "true";//���ڱ�ʹ��
			}
		}
		
		return "false";
	}
		
	//���ñ���߶����ͬ�Ƿ���������ҵ��ʹ��
	public String isCeilingGCInUse1(JBOTransaction tx) throws Exception{
		this.tx = tx;
		String gcSerialNo = (String)inputParameter.getValue("GCSerialNo");
		String applySerialNo = (String)inputParameter.getValue("ApplySerialNo");//ֻ��������������׶λ�ɾ������
		return this.isCeilingGCInUse1(gcSerialNo,applySerialNo);
	}
	
	public String isCeilingGCInUse1(String gcSerialNo,String applySerialNo) throws Exception{
		BusinessObjectManager bomanager = this.getBusinessObjectManager();
		List<BusinessObject>arList = bomanager.loadBusinessObjects("jbo.app.APPLY_RELATIVE", "ObjectType='jbo.guaranty.GUARANTY_CONTRACT'"
				+ " and ObjectNo=:ObjectNo and RelativeType='05'", "ObjectNo",gcSerialNo);
		for(BusinessObject ar:arList){
			String applyNo = ar.getString("ApplySerialNo");
			if(applySerialNo.equals(applyNo)) continue;//���ʳ���
			BusinessObject apply = bomanager.keyLoadBusinessObject("jbo.app.BUSINESS_APPLY", applyNo);
			String status = apply.getString("ApproveStatus");
			if("01".equals(status) || "02".equals(status) || "06".equals(status)){
				return "true";//���ڱ�ʹ��
			}
		}
		
		List<BusinessObject>crList = bomanager.loadBusinessObjects("jbo.app.CONTRACT_RELATIVE", "ObjectType='jbo.guaranty.GUARANTY_CONTRACT'"
				+ " and ObjectNo=:ObjectNo and RelativeType='05'", "ObjectNo",gcSerialNo);
		for(BusinessObject cr:crList){
			String contractNo = cr.getString("ContractSerialNo");
			BusinessObject contract = bomanager.keyLoadBusinessObject("jbo.app.BUSINESS_CONTRACT", contractNo);
			String status = contract.getString("ContractStatus");
			if("01".equals(status) || "02".equals(status) || "03".equals(status)){
				return "true";//���ڱ�ʹ��
			}
		}
		
		return "false";
	}
	
	//�����߶�Ϊ���ȵ�������뵣����ͬ���Ĵ�С
	public String checkGCRelativeAmount(JBOTransaction tx) throws Exception{
		this.tx = tx;
		String gcSerialNo = (String)inputParameter.getValue("GCSerialNo");
		String arSerialNo = (String)inputParameter.getValue("ARSerialNo");
		String guarantyValue = (String)inputParameter.getValue("GuarantyValue");
		String relaAmount = (String)inputParameter.getValue("RelativeAmount");
		return this.checkGCRelativeAmount(gcSerialNo,arSerialNo,Double.parseDouble(guarantyValue),Double.parseDouble(relaAmount));
	}
	
	public String checkGCRelativeAmount(String gcSerialNo,String arSerialNo,double guarantyValue,double relaAmount) throws Exception{
		double usingAmount = 0.0;//ռ�ý��
		
		BusinessObjectManager bomanager = this.getBusinessObjectManager();
		List<BusinessObject>arList = bomanager.loadBusinessObjects("jbo.app.APPLY_RELATIVE", "ObjectType='jbo.guaranty.GUARANTY_CONTRACT'"
				+ " and ObjectNo=:ObjectNo and RelativeType='05'", "ObjectNo",gcSerialNo);
		for(BusinessObject ar:arList){
			if(ar.getKeyString().equals(arSerialNo)) continue;//���ʲ���
			String applyNo = ar.getString("ApplySerialNo");
			BusinessObject apply = bomanager.keyLoadBusinessObject("jbo.app.BUSINESS_APPLY", applyNo);
			String status = apply.getString("ApproveStatus");
			if("01".equals(status) || "02".equals(status) || "06".equals(status)){
				usingAmount += ar.getDouble("RelativeAmount");
			}
		}
		
		List<BusinessObject>crList = bomanager.loadBusinessObjects("jbo.app.CONTRACT_RELATIVE", "ObjectType='jbo.guaranty.GUARANTY_CONTRACT'"
				+ " and ObjectNo=:ObjectNo and RelativeType='05'", "ObjectNo",gcSerialNo);
		for(BusinessObject cr:crList){
			String contractNo = cr.getString("ContractSerialNo");
			BusinessObject contract = bomanager.keyLoadBusinessObject("jbo.app.BUSINESS_CONTRACT", contractNo);
			String status = contract.getString("ContractStatus");
			if("01".equals(status) || "02".equals(status)){
				usingAmount += cr.getDouble("RelativeAmount");
			}
			if("03".equals(status)){//�ѷſ�
				String revolve = contract.getString("RevolveFlag");//1ѭ��2��ѭ��
				if("2".equals(revolve)){
					usingAmount += cr.getDouble("RelativeAmount");
				}
				if("1".equals(revolve)){
					double crRelaAmount = cr.getDouble("RelativeAmount");
					double bcBalance = contract.getDouble("Balance");
					if(bcBalance < crRelaAmount){
						usingAmount += bcBalance;
					}
					else{
						usingAmount += crRelaAmount;
					}
				}
			}
		}
		
		if(relaAmount > (guarantyValue-usingAmount))
			return "false";
		else
			return "true";
	}
	
	//��ȡ��߶ռ�õĽ�������
	public static double getGCUsingAmount(String gcSerialNo,String applySerialNo) throws Exception{
		double usingAmount = 0.0;//ռ�ý��,��������
		
		BusinessObjectManager bomanager = BusinessObjectManager.createBusinessObjectManager();
		List<BusinessObject> bcList = null;
		if(!"".equals(applySerialNo)){
			bcList= bomanager.loadBusinessObjects("jbo.app.BUSINESS_CONTRACT", "ApplySerialNo=:ApplySerialNo and ContractStatus in ('01','02','03')", "ApplySerialNo",applySerialNo);
		}
		 
		String bcSerialNo = "";
		if(bcList != null && bcList.size() > 0) bcSerialNo = bcList.get(0).getKeyString();
				
		List<BusinessObject>arList = bomanager.loadBusinessObjects("jbo.app.APPLY_RELATIVE", "ObjectType='jbo.guaranty.GUARANTY_CONTRACT'"
				+ " and ObjectNo=:ObjectNo and RelativeType='05'", "ObjectNo",gcSerialNo);
		for(BusinessObject ar:arList){
			if(ar.getString("ApplySerialNo").equals(applySerialNo)){//��������
				continue;
			}
			String applyNo = ar.getString("ApplySerialNo");
			BusinessObject apply = bomanager.keyLoadBusinessObject("jbo.app.BUSINESS_APPLY", applyNo);
			String status = apply.getString("ApproveStatus");
			if("01".equals(status) || "02".equals(status) || "06".equals(status)){
				usingAmount += ar.getDouble("RelativeAmount");
			}
		}
		
		List<BusinessObject>crList = bomanager.loadBusinessObjects("jbo.app.CONTRACT_RELATIVE", "ObjectType='jbo.guaranty.GUARANTY_CONTRACT'"
				+ " and ObjectNo=:ObjectNo and RelativeType='05'", "ObjectNo",gcSerialNo);
		for(BusinessObject cr:crList){
			String contractNo = cr.getString("ContractSerialNo");
			if(contractNo.equals(bcSerialNo)){
				continue;
			}
			BusinessObject contract = bomanager.keyLoadBusinessObject("jbo.app.BUSINESS_CONTRACT", contractNo);
			String status = contract.getString("ContractStatus");
			if("01".equals(status) || "02".equals(status)){
				usingAmount += cr.getDouble("RelativeAmount");
			}
			if("03".equals(status)){//�ѷſ�
				String revolve = contract.getString("RevolveFlag");//1ѭ��2��ѭ��
				if("2".equals(revolve)){
					usingAmount += cr.getDouble("RelativeAmount");
				}
				if("1".equals(revolve)){
					double crRelaAmount = cr.getDouble("RelativeAmount");
					double bcBalance = contract.getDouble("Balance");
					if(bcBalance < crRelaAmount){
						usingAmount += bcBalance;
					}
					else{
						usingAmount += crRelaAmount;
					}
				}
			}
		}
		return usingAmount;
	}
	
	
	//ѺƷ������ծȨ֮�Ͳ���С�ڱ��������õĽ��(������)
	public String checkGCUsingAmount(JBOTransaction tx) throws Exception{
		this.tx = tx;
		String gcSerialNo = (String)inputParameter.getValue("GCSerialNo");
		String arSerialNo = (String)inputParameter.getValue("ARSerialNo");
		String relaAmount = (String)inputParameter.getValue("RelativeAmount");
		return this.checkGCUsingAmount(gcSerialNo,arSerialNo,Double.parseDouble(relaAmount));
	}
	
	//���Ľ�������GuarantyObjects.java
	public String checkGCUsingAmount(String gcSerialNo,String arSerialNo,double relaAmount) throws Exception{
		double usingAmount = 0.0;//ռ�ý��,��������
		
		BusinessObjectManager bomanager = this.getBusinessObjectManager();
		List<BusinessObject>arList = bomanager.loadBusinessObjects("jbo.app.APPLY_RELATIVE", "ObjectType='jbo.guaranty.GUARANTY_CONTRACT'"
				+ " and ObjectNo=:ObjectNo and RelativeType='05'", "ObjectNo",gcSerialNo);
		for(BusinessObject ar:arList){
			if(ar.getKeyString().equals(arSerialNo)){//�Ƿ񺬱���
				continue;
			}
			String applyNo = ar.getString("ApplySerialNo");
			BusinessObject apply = bomanager.keyLoadBusinessObject("jbo.app.BUSINESS_APPLY", applyNo);
			String status = apply.getString("ApproveStatus");
			if("01".equals(status) || "02".equals(status) || "06".equals(status)){
				usingAmount += ar.getDouble("RelativeAmount");
			}
		}
		
		List<BusinessObject>crList = bomanager.loadBusinessObjects("jbo.app.CONTRACT_RELATIVE", "ObjectType='jbo.guaranty.GUARANTY_CONTRACT'"
				+ " and ObjectNo=:ObjectNo and RelativeType='05'", "ObjectNo",gcSerialNo);
		for(BusinessObject cr:crList){
			String contractNo = cr.getString("ContractSerialNo");
			BusinessObject contract = bomanager.keyLoadBusinessObject("jbo.app.BUSINESS_CONTRACT", contractNo);
			String status = contract.getString("ContractStatus");
			if("01".equals(status) || "02".equals(status)){
				usingAmount += cr.getDouble("RelativeAmount");
			}
			if("03".equals(status)){//�ѷſ�
				String revolve = contract.getString("RevolveFlag");//1ѭ��2��ѭ��
				if("2".equals(revolve)){
					usingAmount += cr.getDouble("RelativeAmount");
				}
				if("1".equals(revolve)){
					double crRelaAmount = cr.getDouble("RelativeAmount");
					double bcBalance = contract.getDouble("Balance");
					if(bcBalance < crRelaAmount){
						usingAmount += bcBalance;
					}
					else{
						usingAmount += crRelaAmount;
					}
				}
			}
		}
		
		//���㵣����ծȨ���֮��
		double collAmount = 0d;
		List<BusinessObject>grList = bomanager.loadBusinessObjects("jbo.guaranty.GUARANTY_RELATIVE", "GCSerialNo=:GCSerialNo and (Status is null or (Status is not null and Status<>'06')) ", "GCSerialNo",gcSerialNo);     
		if(grList == null || (grList != null && grList.size() == 0))
			return "true";
		for(BusinessObject gr:grList){
			String assetSerialNo = gr.getString("AssetSerialNo");
			if(!StringX.isEmpty(assetSerialNo)){
				double guarantyAmount = gr.getDouble("GuarantyAmount");
				collAmount += guarantyAmount;
			}
		}
				
		if(collAmount >= (usingAmount+relaAmount)){
			return "true";
		}
		else{
			return "false";
		}	
	}
	
	//��߶�����������õĽ�Ӧ����ѺƷ������ծȨ֮�ͣ���߶���ЧʱУ�飩
	//���Ľ�������GuarantyObjects.java
	public static String checkGCUsingAmount(String gcSerialNo) throws Exception{
		double usingAmount = 0.0;//ռ�ý��,��������
		
		BusinessObjectManager bomanager = BusinessObjectManager.createBusinessObjectManager();
		List<BusinessObject>arList = bomanager.loadBusinessObjects("jbo.app.APPLY_RELATIVE", "ObjectType='jbo.guaranty.GUARANTY_CONTRACT'"
				+ " and ObjectNo=:ObjectNo and RelativeType='05'", "ObjectNo",gcSerialNo);
		for(BusinessObject ar:arList){
			String applyNo = ar.getString("ApplySerialNo");
			BusinessObject apply = bomanager.keyLoadBusinessObject("jbo.app.BUSINESS_APPLY", applyNo);
			String status = apply.getString("ApproveStatus");
			if("01".equals(status) || "02".equals(status) || "06".equals(status)){
				usingAmount += ar.getDouble("RelativeAmount");
			}
		}
		
		List<BusinessObject>crList = bomanager.loadBusinessObjects("jbo.app.CONTRACT_RELATIVE", "ObjectType='jbo.guaranty.GUARANTY_CONTRACT'"
				+ " and ObjectNo=:ObjectNo and RelativeType='05'", "ObjectNo",gcSerialNo);
		for(BusinessObject cr:crList){
			String contractNo = cr.getString("ContractSerialNo");
			BusinessObject contract = bomanager.keyLoadBusinessObject("jbo.app.BUSINESS_CONTRACT", contractNo);
			String status = contract.getString("ContractStatus");
			if("01".equals(status) || "02".equals(status)){
				usingAmount += cr.getDouble("RelativeAmount");
			}
			if("03".equals(status)){//�ѷſ�
				String revolve = contract.getString("RevolveFlag");//1ѭ��2��ѭ��
				if("2".equals(revolve)){
					usingAmount += cr.getDouble("RelativeAmount");
				}
				if("1".equals(revolve)){
					double crRelaAmount = cr.getDouble("RelativeAmount");
					double bcBalance = contract.getDouble("Balance");
					if(bcBalance < crRelaAmount){
						usingAmount += bcBalance;
					}
					else{
						usingAmount += crRelaAmount;
					}
				}
			}
		}
		
		//���㵣����ծȨ���֮��
		double collAmount = 0d;
		List<BusinessObject>grList = bomanager.loadBusinessObjects("jbo.guaranty.GUARANTY_RELATIVE", "GCSerialNo=:GCSerialNo and (Status is null or (Status is not null and Status<>'06')) ", "GCSerialNo",gcSerialNo);     
		if(grList == null || (grList != null && grList.size() == 0))
			return "true";
		for(BusinessObject gr:grList){
			String assetSerialNo = gr.getString("AssetSerialNo");
			if(!StringX.isEmpty(assetSerialNo)){
				double guarantyAmount = gr.getDouble("GuarantyAmount");
				collAmount += guarantyAmount;
			}
		}
				
		if(collAmount >= usingAmount){
			return "true";
		}
		else{
			return "false";
		}	
	}
	
	//������߶����ͬ���
	public String getCeilingGCBalance(JBOTransaction tx) throws Exception{
		this.tx = tx;
		String gcSerialNo = (String)inputParameter.getValue("GCSerialNo");
		if(gcSerialNo.equals("")) return "false";
		double balance = this.getCeilingGCBalance1(gcSerialNo);
		if(balance == -1) return "false";
		else return String.valueOf(balance);
	}
	
	public double getCeilingGCBalance(String gcSerialNo) throws Exception{
		double usingAmount = 0.0;//ռ�ý��
		
		BusinessObjectManager bomanager = this.getBusinessObjectManager();
		BusinessObject gcbo = bomanager.keyLoadBusinessObject("jbo.guaranty.GUARANTY_CONTRACT", gcSerialNo);
		if(gcbo==null) return -1;
		
		List<BusinessObject>arList = bomanager.loadBusinessObjects("jbo.app.APPLY_RELATIVE", "ObjectType='jbo.guaranty.GUARANTY_CONTRACT'"
				+ " and ObjectNo=:ObjectNo and RelativeType='05'", "ObjectNo",gcSerialNo);
		for(BusinessObject ar:arList){
			String applyNo = ar.getString("ApplySerialNo");
			BusinessObject apply = bomanager.keyLoadBusinessObject("jbo.app.BUSINESS_APPLY", applyNo);
			if(apply==null)continue;
			String status = apply.getString("ApproveStatus");
			if("01".equals(status) || "02".equals(status) || "06".equals(status)){
				usingAmount += ar.getDouble("RelativeAmount");
			}
		}
		
		List<BusinessObject>crList = bomanager.loadBusinessObjects("jbo.app.CONTRACT_RELATIVE", "ObjectType='jbo.guaranty.GUARANTY_CONTRACT'"
				+ " and ObjectNo=:ObjectNo and RelativeType='05'", "ObjectNo",gcSerialNo);
		for(BusinessObject cr:crList){
			String contractNo = cr.getString("ContractSerialNo");
			BusinessObject contract = bomanager.keyLoadBusinessObject("jbo.app.BUSINESS_CONTRACT", contractNo);
			if(contract==null)continue;
			String status = contract.getString("ContractStatus");
			if("01".equals(status) || "02".equals(status) || "03".equals(status)){
				usingAmount += cr.getDouble("RelativeAmount");
			}
		}
		
		if(gcbo.getDouble("GuarantyValue") < usingAmount) return -1;
		return gcbo.getDouble("GuarantyValue")-usingAmount;
	}
	
	//��������
	public double getCeilingGCBalance1(String gcSerialNo) throws Exception{
		double usingAmount = 0.0;//ռ�ý��
		
		BusinessObjectManager bomanager = this.getBusinessObjectManager();
		BusinessObject gcbo = bomanager.keyLoadBusinessObject("jbo.guaranty.GUARANTY_CONTRACT", gcSerialNo);
		if(gcbo==null) return -1;
		
		String sql1 = "Select sum(nvl(AR.RelativeAmount,0)) as RelativeAmounts from APPLY_RELATIVE AR,BUSINESS_APPLY BA where AR.ObjectType='jbo.guaranty.GUARANTY_CONTRACT' and "
				+ "AR.ObjectNo='"+gcSerialNo+"' and AR.RelativeType='05' and BA.SerialNo = AR.ApplySerialNo and BA.ApproveStatus in ('01','02','06')";
		List<BusinessObject>arAmountList = bomanager.loadBusinessObjects_SQL(sql1, BusinessObject.createBusinessObject());
		if(arAmountList != null && arAmountList.size() > 0){
			String x = arAmountList.get(0).getString("RelativeAmounts");
			if(!StringX.isEmpty(x)){
				double arAmount = Double.parseDouble(x);
				usingAmount += arAmount;
			}
		}
		
		
		String sql2 = "Select sum(nvl(CR.RelativeAmount,0)) as RelativeAmounts from CONTRACT_RELATIVE CR,BUSINESS_CONTRACT BC where CR.ObjectType='jbo.guaranty.GUARANTY_CONTRACT' and "
				+ "CR.ObjectNo='"+gcSerialNo+"' and CR.RelativeType='05' and BC.SerialNo = CR.ContractSerialNo and BC.ContractStatus in ('01','02','03')";
		List<BusinessObject>crAmountList = bomanager.loadBusinessObjects_SQL(sql2, BusinessObject.createBusinessObject());
		if(crAmountList != null && crAmountList.size() > 0){
			String x = crAmountList.get(0).getString("RelativeAmounts");
			if(!StringX.isEmpty(x)){
				double crAmount = Double.parseDouble(x);
				usingAmount += crAmount;
			}
		}
		
		if(gcbo.getDouble("GuarantyValue") < usingAmount) return -1;
		return gcbo.getDouble("GuarantyValue")-usingAmount;
	}
	
	//�ж�ѺƷ�Ƿ���޸ģ��������õ�ѺƷ������������Ч�ĵ�����ͬ�����ñʣ��������޸�
	public static String ifAssetEditable(String assetSerialNo,String gcSerialNo) throws Exception{
		BusinessObjectManager bomanager = BusinessObjectManager.createBusinessObjectManager();
		List<BusinessObject> grList = bomanager.loadBusinessObjects("jbo.guaranty.GUARANTY_RELATIVE", "AssetSerialNo=:AssetSerialNo", "AssetSerialNo",assetSerialNo);
		for(BusinessObject gr:grList){
			String serialNo = gr.getString("GCSerialNo");
			if(StringX.isEmpty(serialNo)) continue;
			if(gcSerialNo.equals(serialNo)) continue;
			BusinessObject gcbo = bomanager.keyLoadBusinessObject("jbo.guaranty.GUARANTY_CONTRACT", serialNo);
			if(gcbo==null) continue;
			String status = gcbo.getString("ContractStatus");
			if("02".equals(status))
				return "false";
		}
		return "true";
	}
	
	//���ݵ�����ͬ��Ż�ȡҵ���ͬ
	public String getBCArtificialNo(JBOTransaction tx) throws Exception{
		this.tx = tx;
		String serialNo = (String)inputParameter.getValue("GCSerialNo");
		return this.getBCArtificialNo(serialNo);
	}
	
	public String getBCArtificialNo(String gcSerialNo) throws Exception{
		BusinessObjectManager bom = this.getBusinessObjectManager();
		List<BusinessObject> crList = bom.loadBusinessObjects("jbo.app.CONTRACT_RELATIVE", "ObjectType='jbo.guaranty.GUARANTY_CONTRACT' and "
				+ "ObjectNo=:ObjectNo and RelativeType='05' ", "ObjectNo",gcSerialNo);
		if(crList!=null && crList.size()!=0){
			String bcSerialNo = crList.get(0).getString("ContractSerialNo");
			if(!StringX.isEmpty(bcSerialNo)){
				BusinessObject bc = bom.keyLoadBusinessObject("jbo.app.BUSINESS_CONTRACT", bcSerialNo);
				if(bc != null){
					return bc.getString("ContractArtificialNo");
				}
			}
		}
		return "";
	}
	
	//�ж��Ƿ����BUSINESS_TRADE,�����ڷ����ʲ���ˮ
	public String getTrade(JBOTransaction tx) throws Exception{
		this.tx = tx;
		String objectNo = (String)inputParameter.getValue("ObjectNo");
		String objectType = (String)inputParameter.getValue("ObjectType");
		return this.getTrade(objectType,objectNo);
	}
	
	public String getTrade(String objectType,String objectNo) throws Exception{
		BusinessObjectManager bomanager = this.getBusinessObjectManager();
		
		List<BusinessObject> btList = bomanager.loadBusinessObjects("jbo.app.BUSINESS_TRADE", "ObjectType=:ObjectType"
				+ " and ObjectNo=:ObjectNo ", "ObjectNo",objectNo,"ObjectType",objectType);
		if(btList == null || (btList != null && btList.size() == 0))
			return "false";
		else{
			BusinessObject trade = btList.get(0);
			String assetSerialNo = trade.getString("AssetSerialNo");
			String assetType = trade.getString("AssetType");
			if(StringX.isEmpty(assetSerialNo) || StringX.isEmpty(assetType))
				return "false";
			
			return assetSerialNo+"@"+assetType;
		}
	}
	
	
	//���������ĵ�����ͬ��ɾ��ʱֻɾ��������ϵ
	public String deleteGCRelative(JBOTransaction tx) throws Exception{
		this.tx = tx;
		
		String serialNo = (String) inputParameter.getValue("SerialNo");
		
		BizObjectManager ar = JBOFactory.getBizObjectManager("jbo.app.APPLY_RELATIVE");
		BizObjectQuery nar = ar.createQuery("SerialNo=:SerialNo");
		nar.setParameter("SerialNo", serialNo);
		List<BizObject> narList = nar.getResultList(false);
		for(BizObject arbo:narList)
		{
			ar.deleteObject(arbo);
		}
		
		return "true";
	}
	
	
	//����ѺƷ�Ƿ񱾵�����ͬ���һ�����Ԥ��Ѻ����ʽ��Ѻ���Ǽǵ�ѺƷ,flag:1Ԥ��Ѻ���2��ʽ��Ѻ���
	public static String lastCollateral(String gcSerialNo,String assetSerialNo,String flag) throws Exception{
		BusinessObjectManager bom = BusinessObjectManager.createBusinessObjectManager();
		List<BusinessObject> grList = bom.loadBusinessObjects("jbo.guaranty.GUARANTY_RELATIVE", "GCSerialNo = :GCSerialNo", "GCSerialNo",gcSerialNo);
		for(BusinessObject bo:grList){
			if(assetSerialNo.equals(bo.getString("AssetSerialNo"))) continue;
			String status = bo.getString("Status");
			if(StringX.isEmpty(status)) return "false";
			if(flag.equals("1")){
				if(status.startsWith("01") || status.startsWith("02"))
					return "false";
			}
			else if(flag.equals("2")){
				if(status.startsWith("01") || status.startsWith("02") || status.startsWith("03"))
					return "false";
			}
			else{}
		}
			
		return "true";
	}
	
	//Ԥ�۷���δ��Ѻ����ʽ��Ѻ����ʾ
	public String preSaleNote(JBOTransaction tx) throws Exception{
		this.tx = tx;
		String grSerialNo = (String)inputParameter.getValue("GRSerialNo");
		String assetSerialNo = (String)inputParameter.getValue("AssetSerialNo");
		return this.preSaleNote(grSerialNo,assetSerialNo);
	}
	
	public String preSaleNote(String grSerialNo,String assetSerialNo) throws Exception{
		BusinessObjectManager bomanager = this.getBusinessObjectManager();
		BusinessObject gr = bomanager.keyLoadBusinessObject("jbo.guaranty.GUARANTY_RELATIVE", grSerialNo);
		BusinessObject ar = bomanager.keyLoadBusinessObject("jbo.guaranty.ASSET_REALTY", assetSerialNo);
		
		if(gr != null && ar != null){
			if("0100".equals(gr.getString("Status"))){
				if("02".equals(ar.getString("HouseStatus"))){//Ԥ�۷�
					return "��ѺƷΪԤ�۷��ݣ���ȷ���Ƿ��Ѱ���Ԥ��Ѻ�Ǽǣ�";
				}
			}
		}
		
		return "true";
	}
	
	//�����ʽ��Ѻ
	public String finishFormalColl(JBOTransaction tx) throws Exception{
		this.tx = tx;
		String grSerialNo = (String)inputParameter.getValue("GRSerialNo");
		String assetSerialNo = (String)inputParameter.getValue("AssetSerialNo");
		return this.finishFormalColl(grSerialNo,assetSerialNo);
	}
	
	public String finishFormalColl(String grSerialNo,String assetSerialNo) throws Exception{
		BusinessObjectManager bomanager = this.getBusinessObjectManager();
		
		BusinessObject gr = bomanager.keyLoadBusinessObject("jbo.guaranty.GUARANTY_RELATIVE", grSerialNo);
		BusinessObject ai = bomanager.keyLoadBusinessObject("jbo.app.ASSET_INFO", assetSerialNo);
		
		if(gr!=null && ai!=null){
			if("05".equals(gr.getString("Status"))){
				return "�ñʵ�Ѻ�Ǽ��������ʽ��Ѻ���ظ�������";
			}
			if("0300".equals(gr.getString("Status"))){
				//return "�ñʵ�Ѻ�Ǽ��Ѿ����Ԥ��Ѻ���ظ�������";
			}
			
			//����ʱУ��Ȩ֤�Ƿ�����,����ѺƷ���Ͳ�������
			String assetType = ai.getString("AssetType");
			if(assetType.startsWith("20")){
				List<BusinessObject> rightCertList = bomanager.loadBusinessObjects("jbo.app.ASSET_RIGHT_CERTIFICATE", "AssetSerialNo=:AssetSerialNo and ObjectType='jbo.guaranty.GUARANTY_RELATIVE' and ObjectNo=:ObjectNo and CertType='2010'", "AssetSerialNo",assetSerialNo,"ObjectNo",grSerialNo);
				if(rightCertList == null || (rightCertList != null && rightCertList.size() == 0)){
					return "ȱ�ٷ���(����)����Ȩ��֤����ڽ����̵�Ѻ�Ǽ�֤����";
				}
				for(BusinessObject o:rightCertList){
					String certNo = o.getString("CertNo");
					if(!StringX.isEmpty(certNo)){
						gr.setAttributeValue("Status", "05");   //CodeNo:GuarantyStatus  05:��ʽ��Ѻ�Ѱ���
						
						String gcSerialNo = gr.getString("GCSerialNo");
						String guarantyTermType = "",guarantyPeriodFlag = "";
						BusinessObject gc = null;
						if(!StringX.isEmpty(gcSerialNo)){
							gc = bomanager.keyLoadBusinessObject("jbo.guaranty.GUARANTY_CONTRACT", gcSerialNo);
							if(gc != null){
								guarantyTermType = gc.getString("GuarantyTermType");//01ȫ�̵���,02�׶��Ե���
								if(StringX.isEmpty(guarantyTermType)) guarantyTermType = "";
								guarantyPeriodFlag = gc.getString("GuarantyPeriodFlag");//01����ʽ��Ѻ,02����
								if(StringX.isEmpty(guarantyPeriodFlag)) guarantyPeriodFlag = "";
								
								//���ݽ׶��Ե���Ҫ���ͷŵ�����ͬ����ΪʧЧ
								if(guarantyTermType.equals("02") && guarantyPeriodFlag.equals("01")){
									if("true".equals(GuarantyContractAction2.lastCollateral(gcSerialNo, assetSerialNo, "2"))){//�Ƿ�õ�����ͬ�����һ����ɵǼǵ�ѺƷ
										gc.setAttributeValue("ContractStatus", "03");//ʧЧ
										bomanager.updateBusinessObject(gc);
									}
								}
							}
						}
						
						ai.setAttributeValue("AssetStatus", "0120");//�ѵ�Ѻ
						bomanager.updateBusinessObject(ai);
						
						gr = GuarantyContractAction2.registerIntf(gr, "04", bomanager);//��Ѻ�Ǽǽӿ�
	
						bomanager.updateBusinessObject(gr);
						bomanager.updateDB();
						
						return "������ɣ�";
					}
					else{
						return "δ¼��Ȩ֤��ţ�";
					}
				}
			}
			else{//�Ƿ��ز�
				gr.setAttributeValue("Status", "05");   //CodeNo:GuarantyStatus  05:��ʽ��Ѻ�Ѱ���
				
				String gcSerialNo = gr.getString("GCSerialNo");
				String guarantyTermType = "",guarantyPeriodFlag = "";
				BusinessObject gc = null;
				if(!StringX.isEmpty(gcSerialNo)){
					gc = bomanager.keyLoadBusinessObject("jbo.guaranty.GUARANTY_CONTRACT", gcSerialNo);
					if(gc != null){
						guarantyTermType = gc.getString("GuarantyTermType");//01ȫ�̵���,02�׶��Ե���
						if(StringX.isEmpty(guarantyTermType)) guarantyTermType = "";
						guarantyPeriodFlag = gc.getString("GuarantyPeriodFlag");//01����ʽ��Ѻ,02����
						if(StringX.isEmpty(guarantyPeriodFlag)) guarantyPeriodFlag = "";
						
						//���ݽ׶��Ե���Ҫ���ͷŵ�����ͬ����ΪʧЧ
						if(guarantyTermType.equals("02") && guarantyPeriodFlag.equals("01")){
							if("true".equals(GuarantyContractAction2.lastCollateral(gcSerialNo, assetSerialNo, "2"))){//�Ƿ�õ�����ͬ�����һ����ɵǼǵ�ѺƷ
								gc.setAttributeValue("ContractStatus", "03");//ʧЧ
								bomanager.updateBusinessObject(gc);
							}
						}
					}
				}

				ai.setAttributeValue("AssetStatus", "0120");//�ѵ�Ѻ
				bomanager.updateBusinessObject(ai);
				
				gr = GuarantyContractAction2.registerIntf(gr, "04", bomanager);//��Ѻ�Ǽǽӿ�
				bomanager.updateBusinessObject(gr);
				
				bomanager.updateDB();
				return "������ɣ�";
			}
		}

		return "����ʧ�ܣ�";
	}
	
	//type:����������� 01-��ʼ����/02-���ƽ�/03-���ͼ�/04-�ѻ�ȡ
	public static BusinessObject registerIntf(BusinessObject gr,String type,BusinessObjectManager bom) throws Exception{
		//�������Ѻ�Ǽ���Ϣ
		String CltlRgstNo="";
		
		gr.setAttributeValue("CMISSERIALNO", CltlRgstNo);
		bom.updateBusinessObject(gr);
		return gr;
	}
	
	//���Ԥ��Ѻ
	public String finishColl(JBOTransaction tx) throws Exception{
		this.tx = tx;
		String grSerialNo = (String)inputParameter.getValue("GRSerialNo");
		String assetSerialNo = (String)inputParameter.getValue("AssetSerialNo");
		return this.finishColl(grSerialNo,assetSerialNo);
	}
	
	public String finishColl(String grSerialNo,String assetSerialNo) throws Exception{
		BusinessObjectManager bomanager = this.getBusinessObjectManager();
		
		BusinessObject gr = bomanager.keyLoadBusinessObject("jbo.guaranty.GUARANTY_RELATIVE", grSerialNo);
		BusinessObject ai = bomanager.keyLoadBusinessObject("jbo.app.ASSET_INFO", assetSerialNo);
		
		if(gr!=null && ai!=null){
			if("0300".equals(gr.getString("Status"))){
				return "�ñʵ�Ѻ�Ǽ��Ѿ����Ԥ��Ѻ���ظ�������";
			}
			if("05".equals(gr.getString("Status"))){
				return "�ñʵ�Ѻ�Ǽ��������ʽ��Ѻ���ظ�������";
			}
			//����ʱУ��Ȩ֤�Ƿ�����,����ѺƷ���Ͳ�������
			String assetType = ai.getString("AssetType");
			if(assetType.startsWith("20")){
				List<BusinessObject> rightCertList = bomanager.loadBusinessObjects("jbo.app.ASSET_RIGHT_CERTIFICATE", "AssetSerialNo=:AssetSerialNo and ObjectType='jbo.guaranty.GUARANTY_RELATIVE' and ObjectNo=:ObjectNo and CertType='2010'", "AssetSerialNo",assetSerialNo,"ObjectNo",grSerialNo);
				if(rightCertList == null || (rightCertList != null && rightCertList.size() == 0)){
					return "ȱ��Ԥ��Ѻ�Ǽ�֤����";
				}
				for(BusinessObject o:rightCertList){
					String certNo = o.getString("CertNo");
					if(!StringX.isEmpty(certNo)){
						gr.setAttributeValue("Status", "0300");   //CodeNo:GuarantyStatus  0300:����Ԥ��Ѻ
						ai.setAttributeValue("AssetStatus", "0110");//��Ԥ��Ѻ
						bomanager.updateBusinessObject(ai);
						gr = GuarantyContractAction2.registerIntf(gr, "04", bomanager);//��Ѻ�Ǽǽӿ�
						bomanager.updateBusinessObject(gr);
						bomanager.updateDB();
						return "������ɣ�";
					}
					else{
						return "δ¼��Ȩ֤��ţ�";
					}
				}
			}
		}
		
		return "����ʧ�ܣ�";
	}
	
	public String getPrjName(JBOTransaction tx) throws Exception{
		this.tx = tx;
		String serialNo = (String)inputParameter.getValue("PrjSerialNo");
		return this.getPrjName(serialNo);
	}
	
	public String getPrjName(String prjSerialNo) throws Exception{
		BusinessObjectManager bom = this.getBusinessObjectManager();
		BusinessObject prj = bom.keyLoadBusinessObject("jbo.prj.PRJ_BASIC_INFO", prjSerialNo);
		String name = "";
		if(prj != null){
			name = prj.getString("ProjectName");
			if(StringX.isEmpty(name)){
				name = "";
			}
		}
		return name;
	}
	
	//����ѺƷϵͳ��Ų�ѯ����ϵͳѺƷ���
	public String getAssetSerialNo(JBOTransaction tx) throws Exception{
		this.tx = tx;
		String serialNo = (String)inputParameter.getValue("ClrSerialNo");
		return this.getAssetSerialNo(serialNo);
	}
	
	public String getAssetSerialNo(String clrSerialNo) throws Exception{
		BusinessObjectManager bom = this.getBusinessObjectManager();
		List<BusinessObject> assets = bom.loadBusinessObjects("jbo.app.ASSET_INFO", "ClrSerialNo=:ClrSerialNo","ClrSerialNo",clrSerialNo);
		if(assets == null || (assets != null && assets.size()==0)) return "false";
		String serialNo = assets.get(0).getKeyString();

		return serialNo;
	}
	
	//������������ɾ����ԱʱҪ�޸�����������֤����Ϣ
	public String updateGroupGCInfo(JBOTransaction tx) throws Exception{
		this.tx = tx;
		String groupSerialNo = (String)inputParameter.getValue("GroupSerialNo");
		String applySerialNo = (String)inputParameter.getValue("ApplySerialNo");
		return this.updateGroupGCInfo(groupSerialNo,applySerialNo);
	}
	
	public String updateGroupGCInfo(String groupSerialNo,String applySerialNo) throws Exception{
		BusinessObjectManager bom = this.getBusinessObjectManager();
		
		BusinessObject apply = bom.keyLoadBusinessObject("jbo.app.BUSINESS_APPLY", applySerialNo);
		String customerID = apply.getString("CustomerID");
		if(StringX.isEmpty(customerID)) customerID = "";
		String customerName = apply.getString("CustomerName");
		if(StringX.isEmpty(customerName)) customerName = "";
		double businessSum = apply.getDouble("BusinessSum");
		
		List<BusinessObject> ars = bom.loadBusinessObjects("jbo.app.APPLY_RELATIVE", "ApplySerialNo=:ApplySerialNo and ObjectType='jbo.guaranty.GUARANTY_CONTRACT' and RelativeType='05'","ApplySerialNo",applySerialNo);
		for(BusinessObject ar:ars){
			String gcSerialNo = ar.getString("ObjectNo");
			BusinessObject gc = bom.keyLoadBusinessObject("jbo.guaranty.GUARANTY_CONTRACT", gcSerialNo);
			if("01030".equals(gc.getString("GuarantyType"))){
				String guarantorID = gc.getString("GuarantorID");
				String guarantorName = gc.getString("GuarantorName");
				double guarantyValue = gc.getDouble("GuarantyValue");
				
				guarantorID = GuarantyContractAction2.delSubString(guarantorID, customerID);
				guarantorName = GuarantyContractAction2.delSubString(guarantorName, customerName);
				guarantyValue -= businessSum;
				
				gc.setAttributeValue("GuarantorID", guarantorID);
				gc.setAttributeValue("GuarantorName", guarantorName);
				gc.setAttributeValue("GuarantyValue", guarantyValue);
				bom.updateBusinessObject(gc);
				bom.deleteBusinessObject(ar);//ɾ������
				bom.updateDB();
				break;
			}
		}
		
		return "true";
	}
	
	//���ַ���s1��ɾ���ַ���s2(s2ǰ����,)
	public static String delSubString(String s1,String s2){
		if(s1.indexOf(s2)<0) return s1;

		int len1 = s1.length();
		int len2 = s2.length();
		
		if(len1 == len2) return "";
		String s3 = ","+s2+",", s4 = ","+s2, s5 = s2+",";
		
		if(s1.indexOf(s3) > 0){//s2λ��s1�м�
			return s1.substring(0, s1.indexOf(s3)).concat(s1.substring(s1.indexOf(s3)+len2+1));
		}
		else if(s1.indexOf(s4)+len2+1 == len1){//λ��s1���
			return s1.substring(0, s1.indexOf(s4));
		}
		else if(s1.indexOf(s5) == 0){//λ��s1��ͷ
			return s1.substring(s5.length());
		}
		else return s1;
	}
}