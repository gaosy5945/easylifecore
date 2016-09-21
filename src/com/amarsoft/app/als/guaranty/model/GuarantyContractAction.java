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
 * GuarantyContractAction1.java 和 GuarantyContractAction2.java是两个写法
 */
public class GuarantyContractAction {
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

	//根据担保合同号获取业务品种，最高额担保时返回空
	public String getProduct(JBOTransaction tx) throws Exception{
		this.tx=tx;
		String objectType = (String)inputParameter.getValue("ObjectType");
		if(objectType==null) objectType="";
		String objectNo = (String)inputParameter.getValue("ObjectNo");
		if(objectNo==null) objectNo="";
		return this.getProduct(objectType,objectNo);
	}
	
	public String getProduct(String objectType,String objectNo) throws Exception{
		if("".equals(objectType) || "".equals(objectNo))//无业务信息，不返回产品品种信息
			return "false";
		BusinessObjectManager bomanager = this.getBusinessObjectManager();
		BusinessObject businessObject = bomanager.keyLoadBusinessObject(objectType, objectNo);
		if(businessObject == null) throw new Exception("类型"+objectType+",编号"+objectNo+"未加载到");
		String productID = businessObject.getString("ProductID");
		if(productID == null) productID="";
		String businessType = businessObject.getString("BusinessType");
		if(businessType == null) businessType="";
		
		return "true@"+productID+"@"+businessType;
	}
	
	//检查该笔最高额担保合同是否已经被引入
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
	
	//检查担保比例是否超过要求
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
	
	//检查该笔最高额担保合同是否正被使用
	public String isCeilingGCInUse(JBOTransaction tx) throws Exception{
		this.tx = tx;
		String gcSerialNo = (String)inputParameter.getValue("GCSerialNo");
		return this.isCeilingGCInUse(gcSerialNo);
	}
	
	public String isCeilingGCInUse(String gcSerialNo) throws Exception{
		BusinessObjectManager bomanager = this.getBusinessObjectManager();
		
		String sql1 = "Select * from APPLY_RELATIVE AR,BUSINESS_APPLY BA where AR.ObjectType='jbo.guaranty.GUARANTY_CONTRACT' and "
				+ "AR.ObjectNo='"+gcSerialNo+"' and AR.RelativeType='05' and AR.ApplySerialNo=BA.SerialNo and BA.ApproveStatus in ('01','02')";
		List<BusinessObject>arList = bomanager.loadBusinessObjects_SQL(sql1, BusinessObject.createBusinessObject());
		for(BusinessObject ar:arList){
			return "true";//正在被使用
		}

		String sql2 = "Select * from CONTRACT_RELATIVE CR,BUSINESS_CONTRACT BC where CR.ObjectType='jbo.guaranty.GUARANTY_CONTRACT' and "
				+ "CR.ObjectNo='"+gcSerialNo+"' and CR.RelativeType='05' and CR.ContractSerialNo=BC.SerialNo and BC.ContractStatus in ('01','02','03')";
		List<BusinessObject>crList = bomanager.loadBusinessObjects_SQL(sql2, BusinessObject.createBusinessObject());
		for(BusinessObject cr:crList){
			return "true";//正在被使用
		}
		
		return "false";
	}
		
	//检查该笔最高额担保合同是否正被其他业务使用
	public String isCeilingGCInUse1(JBOTransaction tx) throws Exception{
		this.tx = tx;
		String gcSerialNo = (String)inputParameter.getValue("GCSerialNo");
		String applySerialNo = (String)inputParameter.getValue("ApplySerialNo");//只有申请审查审批阶段会删除操作
		return this.isCeilingGCInUse1(gcSerialNo,applySerialNo);
	}
	
	public String isCeilingGCInUse1(String gcSerialNo,String applySerialNo) throws Exception{
		BusinessObjectManager bomanager = this.getBusinessObjectManager();
		
		String sql1 = "Select * from APPLY_RELATIVE AR,BUSINESS_APPLY BA where AR.ObjectType='jbo.guaranty.GUARANTY_CONTRACT' and "
				+ "AR.ObjectNo='"+gcSerialNo+"' and AR.RelativeType='05' and AR.ApplySerialNo=BA.SerialNo and "
				+ "BA.ApproveStatus in ('01','02') and BA.SerialNo <> '"+applySerialNo+"'";
		List<BusinessObject>arList = bomanager.loadBusinessObjects_SQL(sql1, BusinessObject.createBusinessObject());
		for(BusinessObject ar:arList){
			return "true";//正在被使用
		}

		String sql2 = "Select * from CONTRACT_RELATIVE CR,BUSINESS_CONTRACT BC where CR.ObjectType='jbo.guaranty.GUARANTY_CONTRACT' and "
				+ "CR.ObjectNo='"+gcSerialNo+"' and CR.RelativeType='05' and CR.ContractSerialNo=BC.SerialNo and BC.ContractStatus in ('01','02','03')";
		List<BusinessObject>crList = bomanager.loadBusinessObjects_SQL(sql2, BusinessObject.createBusinessObject());
		for(BusinessObject cr:crList){
			return "true";//正在被使用
		}
		
		return "false";
	}
	
	//检查最高额为本比担保金额与担保合同余额的大小
	public String checkGCRelativeAmount(JBOTransaction tx) throws Exception{
		this.tx = tx;
		String gcSerialNo = (String)inputParameter.getValue("GCSerialNo");
		String arSerialNo = (String)inputParameter.getValue("ARSerialNo");
		String guarantyValue = (String)inputParameter.getValue("GuarantyValue");
		String relaAmount = (String)inputParameter.getValue("RelativeAmount");
		return this.checkGCRelativeAmount(tx,gcSerialNo,arSerialNo,Double.parseDouble(guarantyValue),Double.parseDouble(relaAmount));
	}
	
	public String checkGCRelativeAmount(JBOTransaction tx,String gcSerialNo,String arSerialNo,double guarantyValue,double relaAmount) throws Exception{
		BizObjectManager arm = JBOFactory.getBizObjectManager("jbo.app.APPLY_RELATIVE");
		tx.join(arm);
		GuarantyObjects go = new GuarantyObjects();
		go.setCurSerialNo(arSerialNo);
		go.load(tx.getConnection(arm), "jbo.guaranty.GUARANTY_CONTRACT", gcSerialNo);
		go.calcBalance();
		double usingAmount = go.getUseAmount();
		
		if(relaAmount > (guarantyValue-usingAmount))
			return "false";
		else
			return "true";
	}
	
	//获取最高额被占用的金额，除本笔
	public static double getGCUsingAmount(JBOTransaction tx,String gcSerialNo,String applySerialNo) throws Exception{
		BizObjectManager arm = JBOFactory.getBizObjectManager("jbo.app.APPLY_RELATIVE");
		tx.join(arm);
		GuarantyObjects go = new GuarantyObjects();
		go.setCurSerialNo(applySerialNo);
		go.load(tx.getConnection(arm), "jbo.guaranty.GUARANTY_CONTRACT", gcSerialNo);
		go.calcBalance();
		double usingAmount = go.getUseAmount();

		return usingAmount;
	}
	
	//获取担保变更后最高额被占用的金额，除本笔
	public static double getGCChangeUsingAmount(JBOTransaction tx,String gcSerialNo,String contractSerialNo) throws Exception{
		BizObjectManager arm = JBOFactory.getBizObjectManager("jbo.app.CONTRACT_RELATIVE");
		tx.join(arm);
		GuarantyObjects go = new GuarantyObjects();
		go.setCurSerialNo(contractSerialNo);
		go.load(tx.getConnection(arm), "jbo.guaranty.GUARANTY_CONTRACT", gcSerialNo);
		go.calcBalance();
		double usingAmount = go.getUseAmount();

		return usingAmount;
	}
	
	//计算最高额担保合同余额
	public String getCeilingGCBalance(JBOTransaction tx) throws Exception{
		this.tx = tx;
		String gcSerialNo = (String)inputParameter.getValue("GCSerialNo");
		String arSerialNo = (String)inputParameter.getValue("ARSerialNo");
		if(gcSerialNo == null || "".equals(gcSerialNo)) return "false";
		BizObjectManager arm = JBOFactory.getBizObjectManager("jbo.app.APPLY_RELATIVE");
		tx.join(arm);
		
		GuarantyObjects go = new GuarantyObjects();
		go.setCurSerialNo(arSerialNo);
		go.load(tx.getConnection(arm), "jbo.guaranty.GUARANTY_CONTRACT", gcSerialNo);
		double balance = go.calcBalance();
		if(balance == -1) return "false";
		else return String.valueOf(balance);
	}
	
	//判断押品是否可修改，对于引用的押品，若存在已生效的担保合同（除该笔），不可修改
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
	
	//根据担保合同编号获取业务合同
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
	
	//判断是否存在BUSINESS_TRADE,若存在返回资产流水
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
	
	
	//如果是引入的担保合同，删除时只删除关联关系
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
	
	
	//检查该押品是否本担保合同最后一个完成预抵押（正式抵押）登记的押品,flag:1预抵押完成2正式抵押完成
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
	
	//预售房从未抵押到正式抵押需提示
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
				if("02".equals(ar.getString("HouseStatus"))){//预售房
					return "该押品为预售房屋，请确认是否已办妥预抵押登记？";
				}
			}
		}
		
		return "true";
	}
	
	//完成正式抵押
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
				return "该笔抵押登记已完成正式抵押，重复操作！";
			}
			if("0300".equals(gr.getString("Status"))){
				//return "该笔抵押登记已经完成预抵押，重复操作！";
			}
			
			//房产时校验权证是否输入,其他押品类型不作控制
			String assetType = ai.getString("AssetType");
			if(assetType.startsWith("20")){
				List<BusinessObject> rightCertList = bomanager.loadBusinessObjects("jbo.app.ASSET_RIGHT_CERTIFICATE", "AssetSerialNo=:AssetSerialNo and ObjectType='jbo.guaranty.GUARANTY_RELATIVE' and ObjectNo=:ObjectNo and CertType='2010'", "AssetSerialNo",assetSerialNo,"ObjectNo",grSerialNo);
				if(rightCertList == null || (rightCertList != null && rightCertList.size() == 0)){
					return "缺少房屋(土地)他项权利证书或在建工程抵押登记证明！";
				}
				for(BusinessObject o:rightCertList){
					String certNo = o.getString("CertNo");
					if(!StringX.isEmpty(certNo)){
						gr.setAttributeValue("Status", "05");   //CodeNo:GuarantyStatus  05:正式抵押已办妥
						
						String gcSerialNo = gr.getString("GCSerialNo");
						String guarantyTermType = "",guarantyPeriodFlag = "";
						BusinessObject gc = null;
						if(!StringX.isEmpty(gcSerialNo)){
							gc = bomanager.keyLoadBusinessObject("jbo.guaranty.GUARANTY_CONTRACT", gcSerialNo);
							if(gc != null){
								guarantyTermType = gc.getString("GuarantyTermType");//01全程担保,02阶段性担保
								if(StringX.isEmpty(guarantyTermType)) guarantyTermType = "";
								guarantyPeriodFlag = gc.getString("GuarantyPeriodFlag");//01已正式抵押,02其他
								if(StringX.isEmpty(guarantyPeriodFlag)) guarantyPeriodFlag = "";
								
								//根据阶段性担保要求释放担保合同，置为失效
								if(guarantyTermType.equals("02") && guarantyPeriodFlag.equals("01")){
									if("true".equals(GuarantyContractAction1.lastCollateral(gcSerialNo, assetSerialNo, "2"))){//是否该担保合同的最后一个完成登记的押品
										gc.setAttributeValue("ContractStatus", "03");//失效
										bomanager.updateBusinessObject(gc);
									}
								}
							}
						}
						
						ai.setAttributeValue("AssetStatus", "0120");//已抵押
						bomanager.updateBusinessObject(ai);
						//办妥正式抵押，更新担保合同状态为已失效
						updateGCStatus(grSerialNo);
						
						gr = GuarantyContractAction1.registerIntf(gr, "04", bomanager);//抵押登记接口
	
						bomanager.updateBusinessObject(gr);
						bomanager.updateDB();
						
						return "操作完成！";
					}
					else{
						return "未录入权证编号！";
					}
				}
			}
			else{//非房地产
				gr.setAttributeValue("Status", "05");   //CodeNo:GuarantyStatus  05:正式抵押已办妥
				
				String gcSerialNo = gr.getString("GCSerialNo");
				String guarantyTermType = "",guarantyPeriodFlag = "";
				BusinessObject gc = null;
				if(!StringX.isEmpty(gcSerialNo)){
					gc = bomanager.keyLoadBusinessObject("jbo.guaranty.GUARANTY_CONTRACT", gcSerialNo);
					if(gc != null){
						guarantyTermType = gc.getString("GuarantyTermType");//01全程担保,02阶段性担保
						if(StringX.isEmpty(guarantyTermType)) guarantyTermType = "";
						guarantyPeriodFlag = gc.getString("GuarantyPeriodFlag");//01已正式抵押,02其他
						if(StringX.isEmpty(guarantyPeriodFlag)) guarantyPeriodFlag = "";
						
						//根据阶段性担保要求释放担保合同，置为失效
						if(guarantyTermType.equals("02") && guarantyPeriodFlag.equals("01")){
							if("true".equals(GuarantyContractAction1.lastCollateral(gcSerialNo, assetSerialNo, "2"))){//是否该担保合同的最后一个完成登记的押品
								gc.setAttributeValue("ContractStatus", "03");//失效
								bomanager.updateBusinessObject(gc);
							}
						}
					}
				}

				ai.setAttributeValue("AssetStatus", "0120");//已抵押
				bomanager.updateBusinessObject(ai);
				
				gr = GuarantyContractAction1.registerIntf(gr, "04", bomanager);//抵押登记接口
				bomanager.updateBusinessObject(gr);
				
				bomanager.updateDB();
				return "操作完成！";
			}
		}

		return "操作失败！";
	}
	
	//type:办理进度类型 01-开始办理/02-已移交/03-已送件/04-已获取
	public static BusinessObject registerIntf(BusinessObject gr,String type,BusinessObjectManager bom) throws Exception{
		//保存抵质押登记信息
		String CltlRgstNo="";
		
		
		gr.setAttributeValue("CMISSERIALNO", CltlRgstNo);
		bom.updateBusinessObject(gr);
		return gr;
	}
	
	//完成预抵押
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
				return "该笔抵押登记已经完成预抵押，重复操作！";
			}
			if("05".equals(gr.getString("Status"))){
				return "该笔抵押登记已完成正式抵押，重复操作！";
			}
			//房产时校验权证是否输入,其他押品类型不作控制
			String assetType = ai.getString("AssetType");
			if(assetType.startsWith("20")){
				List<BusinessObject> rightCertList = bomanager.loadBusinessObjects("jbo.app.ASSET_RIGHT_CERTIFICATE", "AssetSerialNo=:AssetSerialNo and ObjectType='jbo.guaranty.GUARANTY_RELATIVE' and ObjectNo=:ObjectNo and CertType='2010'", "AssetSerialNo",assetSerialNo,"ObjectNo",grSerialNo);
				if(rightCertList == null || (rightCertList != null && rightCertList.size() == 0)){
					return "缺少预抵押登记证明！";
				}
				for(BusinessObject o:rightCertList){
					String certNo = o.getString("CertNo");
					if(!StringX.isEmpty(certNo)){
						gr.setAttributeValue("Status", "0300");   //CodeNo:GuarantyStatus  0300:办妥预抵押
						ai.setAttributeValue("AssetStatus", "0110");//已预抵押
						bomanager.updateBusinessObject(ai);
						//gr = GuarantyContractAction.registerIntf(gr, "04", bomanager);//抵押登记接口
						bomanager.updateBusinessObject(gr);
						bomanager.updateDB();
						//办妥正式抵押，更新担保合同状态为已失效
						//updateGCStatus(grSerialNo);
						return "操作完成！";
					}
					else{
						return "未录入权证编号！";
					}
				}
			}
		}
		
		return "操作失败！";
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
	
	//根据押品系统编号查询零售系统押品编号
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
	
	//根据押品编号查询押品系统押品编号
	public String getCLRSerialNo(JBOTransaction tx) throws Exception{
		this.tx = tx;
		String serialNo = (String)inputParameter.getValue("SerialNo");
		return this.getCLRSerialNo(serialNo);
	}
	
	public String getCLRSerialNo(String serialNo) throws Exception{
		BusinessObjectManager bom = this.getBusinessObjectManager();
		BusinessObject asset = bom.keyLoadBusinessObject("jbo.app.ASSET_INFO", serialNo);
		if(asset == null) return "false";
		String clrSerialNo = asset.getString("CLRSerialNo");
		if(StringX.isEmpty(clrSerialNo))
			clrSerialNo = "";
		return clrSerialNo;
	}
	
	public String ifGRExists(JBOTransaction tx) throws Exception{
		this.tx = tx;
		String serialNo = (String)inputParameter.getValue("SerialNo");
		return this.ifGRExists(serialNo);
	}
	
	public String ifGRExists(String serialNo) throws Exception{
		BusinessObjectManager bom = this.getBusinessObjectManager();
		BusinessObject gr = bom.keyLoadBusinessObject("jbo.guaranty.GUARANTY_RELATIVE", serialNo);
		if(gr == null ) return "false";
		else return "true";
	}
	
	//联贷联保申请删除成员时要修改联贷联保保证的信息
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
				
				guarantorID = GuarantyContractAction1.delSubString(guarantorID, customerID);
				guarantorName = GuarantyContractAction1.delSubString(guarantorName, customerName);
				guarantyValue -= businessSum;
				
				gc.setAttributeValue("GuarantorID", guarantorID);
				gc.setAttributeValue("GuarantorName", guarantorName);
				gc.setAttributeValue("GuarantyValue", guarantyValue);
				bom.updateBusinessObject(gc);
				bom.deleteBusinessObject(ar);//删除担保
				bom.updateDB();
				break;
			}
		}
		
		return "true";
	}
	
	//从字符串s1中删除字符串s2(s2前后有,)
	public static String delSubString(String s1,String s2){
		if(s1.indexOf(s2)<0) return s1;

		int len1 = s1.length();
		int len2 = s2.length();
		
		if(len1 == len2) return "";
		String s3 = ","+s2+",", s4 = ","+s2, s5 = s2+",";
		
		if(s1.indexOf(s3) > 0){//s2位于s1中间
			return s1.substring(0, s1.indexOf(s3)).concat(s1.substring(s1.indexOf(s3)+len2+1));
		}
		else if(s1.indexOf(s4)+len2+1 == len1){//位于s1最后
			return s1.substring(0, s1.indexOf(s4));
		}
		else if(s1.indexOf(s5) == 0){//位于s1开头
			return s1.substring(s5.length());
		}
		else return s1;
	}
	
	//办妥正式抵押，更新担保合同状态为已失效
	public void updateGCStatus(String grSerialNo) throws Exception{
		//通过GRSerialNo查询Guaranty_Relative，找到对应的担保流水号GCSerialNo
		BizObjectManager table = JBOFactory.getBizObjectManager("jbo.guaranty.GUARANTY_RELATIVE");
		tx.join(table);
		BizObjectQuery q = table.createQuery("SerialNo=:SerialNo").setParameter("SerialNo", grSerialNo);
		BizObject pr = q.getSingleResult(false);
		if(pr!=null)
		{
			String GCSerialNo = pr.getAttribute("GCSerialNo").getString();
			//通过担保流水号GCSerialNo查询Contract_Relative，找到合同编号ContractSerialNo，可能有多条，故用list
			BizObjectManager tableCR = JBOFactory.getBizObjectManager("jbo.app.CONTRACT_RELATIVE");
			tx.join(tableCR);
			BizObjectQuery qCR = tableCR.createQuery("ObjectNo=:ObjectNo and ObjectType='jbo.guaranty.GUARANTY_CONTRACT'").setParameter("ObjectNo", GCSerialNo);
			List<BizObject> DataLast = qCR.getResultList(false);
			if(DataLast!=null){
				for(BizObject bo:DataLast){
					String ContractSerialNo = bo.getAttribute("ContractSerialNo").getString();
					//拿每一个合同编号ContractSerialNo再去查询Contract_Relative，找到担保流水号ObjectNo，可能有多条，故用list
					BizObjectQuery qCRGC = tableCR.createQuery("ContractSerialNo=:ContractSerialNo and ObjectType='jbo.guaranty.GUARANTY_CONTRACT'").setParameter("ContractSerialNo", ContractSerialNo);
					List<BizObject> DataLastCRGC = qCRGC.getResultList(false);
					if(DataLast!=null){
						for(BizObject boCRGC:DataLastCRGC){
							String ObjectNo = boCRGC.getAttribute("ObjectNo").getString();
							//将本担保信息排除
							if(!ObjectNo.equals(GCSerialNo)){
								//拿每一个担保流水号ObjectNo查询Guaranty_Contract，并取出担保方式为保证、担保期限为阶段性担保那一条，将过滤出的担保信息状态更新为已失效03
								BizObjectManager tableGC = JBOFactory.getBizObjectManager("jbo.guaranty.GUARANTY_CONTRACT");
								tx.join(tableGC);
								BizObjectQuery qGC = tableGC.createQuery("SerialNo=:SerialNo and GuarantyType like '010%' and GuarantyTermType = '02' and GuarantyPeriodFlag = '01'").setParameter("SerialNo", ObjectNo);
								BizObject prGC = qGC.getSingleResult(true);
								if(prGC != null){
									tableGC.createQuery("UPDATE O SET CONTRACTSTATUS =:CONTRACTSTATUS WHERE SERIALNO =:SERIALNO")
									.setParameter("CONTRACTSTATUS", "03").setParameter("SERIALNO", ObjectNo).executeUpdate();
								}
							}
						}
					}
				}
			}
		}
	}
}