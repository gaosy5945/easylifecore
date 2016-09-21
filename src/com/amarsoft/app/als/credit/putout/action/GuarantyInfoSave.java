package com.amarsoft.app.als.credit.putout.action;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.als.credit.guaranty.guarantycontract.CeilingCmis;
import com.amarsoft.app.als.guaranty.model.GuarantyContractAction;
import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.jbo.LocalTransaction;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.are.util.ASValuePool;
import com.amarsoft.are.util.json.JSONObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.dict.als.cache.CodeCache;



/**
 * @author t-wur
 *
 */
public class GuarantyInfoSave {
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

	public String saveGuaranty(JBOTransaction tx) throws Exception{
		this.tx=tx;
		getBusinessObjectManager();
		String serialNo = (String)inputParameter.getValue("SerialNo");
		String applySerialNo = (String)inputParameter.getValue("ApplySerialNo");
		if(StringX.isEmpty(applySerialNo)) applySerialNo = "";
		return this.saveGuaranty(serialNo,applySerialNo,tx);
	}
	
	public String saveGuaranty(String serialNo,String applySerialNo,JBOTransaction tx) throws Exception{
		String result = "true";
		BusinessObjectManager bomanager = this.getBusinessObjectManager();
		BusinessObject gc = bomanager.keyLoadBusinessObject("jbo.guaranty.GUARANTY_CONTRACT", serialNo);
		
		//生成发送押品系统的数据
		String GntPrpslNo = gc.getString("SerialNo");//担保方案编号
		String GntPrpslType = gc.getString("GUARANTYTYPE");//担保方案类型
		if("02010".equals(GntPrpslType)||"02060".equals(GntPrpslType)){
			 GntPrpslType = "01";
		}else if("040".equals(GntPrpslType)){
			 GntPrpslType = "02";
		}
		double UsedGntAmt = Double.valueOf("0");//已引用担保金额
		String GntPrpslMode = gc.getString("CONTRACTTYPE");//担保方案方式
		if("010".equals(GntPrpslMode)){
			GntPrpslMode = "01";
		}else if("020".equals(GntPrpslMode)){
			GntPrpslMode = "02";
			UsedGntAmt = GuarantyContractAction.getGCUsingAmount(tx,serialNo, applySerialNo);
		}
		String GnrNo = gc.getString("GUARANTORID");//担保人编号
		String VrtlPrpslFlag = "1";//虚拟方案标志
		String FrmlPrpslFlag = "1";//正式方案标志
		String IndpdLglTxFlag = "0";//单独法律文本标志
		String GntCrRtCcy = gc.getString("GUARANTYCURRENCY");//担保债权币种

		com.amarsoft.dict.als.object.Item item = CodeCache.getItem("Currency", GntCrRtCcy);
		if(item != null) GntCrRtCcy = item.getSortNo();
		else GntCrRtCcy = "01";
		
		String Status = gc.getString("CONTRACTSTATUS");//状态
		String InputUserId = gc.getString("INPUTORGID");//录入用户ID
		String InputInstId = gc.getString("INPUTUSERID");//录入机构ID
		String GuarantorName = gc.getString("GuarantorName");
		double GntCrRtAmt = gc.getDouble("GuarantyValue") ;//担保债权金额用担保合同金额
	    String assetserialno = CeilingCmis.getAssetSerialno(GntPrpslNo);//抵质押物编号
	    String clrserialno = ""; 
	    String[] assetserialnoArray =  assetserialno.split(",");
	    String[] clrserialnoArray = new String[assetserialnoArray.length];
	    for(int i=0; i<assetserialnoArray.length; i++){
		   BizObject biz = JBOFactory.getFactory().getManager("jbo.app.ASSET_INFO").createQuery("O.serialNo = :SERIALNO").setParameter("SERIALNO", assetserialnoArray[i]).getSingleResult();
		   if(biz==null){
			   result = "生效失败@当前担保合同未录入押品信息！不可以生效！";
			   break;
		   }
		   clrserialnoArray[i] = biz.getAttribute("CLRSERIALNO").toString();
		   clrserialno += clrserialnoArray[i] + "@";
	   }
	   if(!"true".equals(result)){
		   return result;
	   }
	   clrserialno = clrserialno.substring(0, clrserialno.length()-1);
	   clrserialno = "'"+ clrserialno.replace("@", "','")+"'";
 
		//保存担保方案及其关联信息接口
	   try{
		   Transaction Sqlca = Transaction.createTransaction(tx);
		  // OCITransaction oci = ClrInstance.GntPrpslAndInfoSave(GntPrpslNo,GntPrpslType,GntPrpslMode,GnrNo,VrtlPrpslFlag,FrmlPrpslFlag,IndpdLglTxFlag,GntCrRtCcy,UsedGntAmt,Status,InputUserId,InputInstId,GntCrRtAmt,GuarantorName,clrserialno,Sqlca.getConnection());
	   }catch(Exception ex)
		{
			ex.printStackTrace();
			ARE.getLog().error("GUARANTY_CONTRACT_"+gc.getKeyString()+"_save_error.");
			throw ex;
		}
	   
		return result;
	}

	public String saveGuarantyChange(String serialNo,String ContractSerialNo,JBOTransaction tx) throws Exception{
		String result = "true";
		BusinessObjectManager bomanager = BusinessObjectManager.createBusinessObjectManager(tx);
		BusinessObject gc = bomanager.keyLoadBusinessObject("jbo.guaranty.GUARANTY_CONTRACT", serialNo);
		
		//生成发送押品系统的数据
		String GntPrpslNo = gc.getString("SerialNo");//担保方案编号
		String GntPrpslType = gc.getString("GUARANTYTYPE");//担保方案类型
		if("02010".equals(GntPrpslType)||"02060".equals(GntPrpslType)){
			 GntPrpslType = "01";
		}else if("040".equals(GntPrpslType)){
			 GntPrpslType = "02";
		}
		double UsedGntAmt = Double.valueOf("0");//已引用担保金额
		String GntPrpslMode = gc.getString("CONTRACTTYPE");//担保方案方式
		if("010".equals(GntPrpslMode)){
			GntPrpslMode = "01";
		}else if("020".equals(GntPrpslMode)){
			GntPrpslMode = "02";
			UsedGntAmt = GuarantyContractAction.getGCChangeUsingAmount(tx,serialNo, ContractSerialNo);
		}
		String GnrNo = gc.getString("GUARANTORID");//担保人编号
		String VrtlPrpslFlag = "1";//虚拟方案标志
		String FrmlPrpslFlag = "1";//正式方案标志
		String IndpdLglTxFlag = "0";//单独法律文本标志
		String GntCrRtCcy = gc.getString("GUARANTYCURRENCY");//担保债权币种

		com.amarsoft.dict.als.object.Item item = CodeCache.getItem("Currency", GntCrRtCcy);
		if(item != null) GntCrRtCcy = item.getSortNo();
		else GntCrRtCcy = "01";
		
		String Status = gc.getString("CONTRACTSTATUS");//状态
		String InputUserId = gc.getString("INPUTORGID");//录入用户ID
		String InputInstId = gc.getString("INPUTUSERID");//录入机构ID
		String GuarantorName = gc.getString("GuarantorName");
		double GntCrRtAmt = gc.getDouble("GuarantyValue") ;//担保债权金额用担保合同金额
	    //String assetserialno = CeilingCmis.getAssetSerialno(GntPrpslNo);//抵质押物编号
		
		String selectGRSql = " GCSerialNo=:GCSerialNo ";
		List<BusinessObject> grList = bomanager.loadBusinessObjects("jbo.guaranty.GUARANTY_RELATIVE", selectGRSql, "GCSerialNo", GntPrpslNo);
		String clrserialno = ""; 
		for(BusinessObject gr:grList){
			String assetserialno = "";
			assetserialno = gr.getString("AssetSerialNo");
			if(!StringX.isEmpty(assetserialno)){
				BusinessObject aiInfo = bomanager.keyLoadBusinessObject("jbo.app.ASSET_INFO", assetserialno);
			   if(aiInfo==null){
				   result = "生效失败@当前担保合同未录入押品信息！不可以生效！";
				   break;
			   }
			   clrserialno += aiInfo.getString("CLRSERIALNO")+"@";
			}
		}
		/*
	    String clrserialno = ""; 
	    String[] assetserialnoArray =  assetserialno.split(",");
	    String[] clrserialnoArray = new String[assetserialnoArray.length];
	    for(int i=0; i<assetserialnoArray.length; i++){
			   BizObject biz = JBOFactory.getFactory().getManager("jbo.app.ASSET_INFO").createQuery("O.serialNo = :SERIALNO").setParameter("SERIALNO", assetserialnoArray[i]).getSingleResult();
			   if(biz==null){
				   result = "生效失败@当前担保合同未录入押品信息！不可以生效！";
				   break;
			   }
			   clrserialnoArray[i] = biz.getAttribute("CLRSERIALNO").toString();
			   clrserialno += clrserialnoArray[i] + "@";
	   }*/
	   if(!"true".equals(result)){
		   return result;
	   }
	   clrserialno = clrserialno.substring(0, clrserialno.length()-1);
	   clrserialno = "'"+ clrserialno.replace("@", "','")+"'";
 
		//保存担保方案及其关联信息接口
	   try{
		   Transaction Sqlca = Transaction.createTransaction(tx);
		   //OCITransaction oci = ClrInstance.GntPrpslAndInfoSave(GntPrpslNo,GntPrpslType,GntPrpslMode,GnrNo,VrtlPrpslFlag,FrmlPrpslFlag,IndpdLglTxFlag,GntCrRtCcy,UsedGntAmt,Status,InputUserId,InputInstId,GntCrRtAmt,GuarantorName,clrserialno,Sqlca.getConnection());
	   }catch(Exception ex)
		{
			ex.printStackTrace();
			ARE.getLog().error("GUARANTY_CONTRACT_"+gc.getKeyString()+"_save_error.");
			throw ex;
		}
	   
		return result;
	}
}