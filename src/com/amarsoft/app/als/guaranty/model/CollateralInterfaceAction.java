package com.amarsoft.app.als.guaranty.model;

import java.util.List;

import com.amarsoft.app.als.awe.ow.ALSBusinessProcess;
import com.amarsoft.app.als.awe.script.WebBusinessProcessor;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.util.ObjectWindowHelper;
import com.amarsoft.app.als.credit.apply.action.CollateralTemplate;
import com.amarsoft.app.als.credit.guaranty.guarantycontract.CeilingCmis;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.jbo.impl.StateBizObject;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.are.util.json.JSONElement;
import com.amarsoft.are.util.json.JSONEncoder;
import com.amarsoft.are.util.json.JSONObject;
import com.amarsoft.awe.control.model.Component;
import com.amarsoft.awe.dw.ASDataObject;

public class CollateralInterfaceAction extends WebBusinessProcessor {
	//押品唯一性校验
	public String checkUniq(JBOTransaction tx) throws Exception{
		this.setTx(tx);
		this.getBusinessObjectManager();
	
		JSONObject aidata = (JSONObject)this.inputParameter.getValue("aidata");

		JSONObject data = (JSONObject)aidata.get(0).getValue();
		BusinessObject aiObject = ObjectWindowHelper.createBusinessObject_JSON(data);

		String assetType = aiObject.getString("AssetType");
		String clrSerialNo = aiObject.getString("CLRSerialNo");
		String inputUserID = aiObject.getString("InputUserID");
		String inputOrgID = aiObject.getString("InputOrgID");
		
		String attribute4 = CeilingCmis.getAttribute4(assetType);
	    String attribute5 = CeilingCmis.getAttribute5(assetType);
	    String CoreIdntfyElmt = "";
	    String AxlryIdntfyElmt = "";
	    if(StringX.isEmpty(attribute4)){
	    	CoreIdntfyElmt = "{}";
	    }
	    else{
	    	String[] array4 = attribute4.split(",");
	    	JSONObject businessObject = JSONObject.createObject();
		    for(int i = 0 ; i < array4.length ; i++){		        
				businessObject.appendElement(JSONElement.valueOf(array4[i],aiObject.getString(CollateralInterfaceAction.parseElement(array4[i]))));	
			}    
		    CoreIdntfyElmt = JSONEncoder.encode(businessObject);//核心识别要素
	    }
	    if(StringX.isEmpty(attribute5)){
	    	AxlryIdntfyElmt = "{}";
	    }else {
	    	String[] array5 = attribute5.split(",");
			JSONObject businessObject1 = JSONObject.createObject();
			for(int i = 0 ; i < array5.length ; i++){		        
				businessObject1.appendElement(JSONElement.valueOf(array5[i],aiObject.getString(CollateralInterfaceAction.parseElement(array5[i]))));		
			}
			AxlryIdntfyElmt = JSONEncoder.encode(businessObject1);//辅助识别要素
		}  
	    
	    //人工确认置0
	    /*
		OCITransaction oci1 = ClrInstance.CltlUnqChk(assetType,CoreIdntfyElmt,AxlryIdntfyElmt,"0","0",inputUserID,inputOrgID,tx.getConnection(this.getBusinessObjectManager().getBizObjectManager(aiObject.getObjectType())));
	    String ChkRsltFlag = oci1.getOMessage("SysBody").getFieldByTag("SvcBody").getObjectMessage().getFieldValue("ChkRsltFlag");
	    //MrtgPlgCltlNo = oci1.getOMessage("SysBody").getFieldByTag("SvcBody").getObjectMessage().getFieldValue("MrtgPlgCltlNo");
	    List<Message> imessage = oci1.getOMessage("SysBody").getFieldByTag("SvcBody").getObjectMessage().getFieldByTag("ReptCltlInfo").getFieldArrayValue();
	    if(ChkRsltFlag.equals("01")){//通过
			return "01";
		}
	    else if(ChkRsltFlag.equals("02") && imessage != null && imessage.size() == 1 && clrSerialNo != null && clrSerialNo.equals(imessage.get(0).getFieldValue("ReptMrtgPlgCltlNo")) )
	    {
	    	return "01";//唯一性校验只有本笔押品也算做非重复。
	    }
	    else if(clrSerialNo != null && !"".equals(clrSerialNo) && ChkRsltFlag.equals("03"))
	    {
	    	return "01";//该笔押品存在押品系统编号，存在疑似的押品则不提示。
	    }
		else if(ChkRsltFlag.equals("02") || ChkRsltFlag.equals("03")){//重复或疑似重复
			String collNo = "",collName = "",collType = "",collVal = "";
			if(imessage != null){
				for(int i = 0; i < imessage.size() ; i ++){
					Message message = imessage.get(i);
 					String ReptMrtgPlgCltlNo = message.getFieldValue("ReptMrtgPlgCltlNo");//重复抵质押物编号
 					String CltlName = message.getFieldValue("CltlName");//重复抵质押物名称
 					String CltlType = message.getFieldValue("CltlType");//重复抵质押物类型
 					String EstVal = message.getFieldValue("EstVal");//重复抵质押物评估价值
 					if(StringX.isEmpty(CltlName)){
 						CltlName = "NAV";
 					}
 					if(StringX.isEmpty(CltlType)){
 						CltlType = "NAV";
 					}
 					if(StringX.isEmpty(EstVal)){
 						EstVal = "NAV";
 					}
 					
					collNo += (ReptMrtgPlgCltlNo+",");
					collName += (CltlName.replaceAll("#", "＃").replaceAll(",","，").replaceAll("&", "＆")+",");
					collType += (CltlType+",");
					collVal += (EstVal+",");
					if(i >= 9) break;
				}
				if(collNo.length() > 0) collNo = collNo.substring(0, collNo.length()-1);
				if(collName.length() > 0) collName = collName.substring(0, collName.length()-1);
				if(collType.length() > 0) collType = collType.substring(0, collType.length()-1);
				if(collVal.length() > 0) collVal = collVal.substring(0, collVal.length()-1);
			}
			return ChkRsltFlag+"@"+collNo+"@"+collName+"@"+collType+"@"+collVal;
		}
		else throw new Exception("押品系统未返回校验结果标识【ChkRsltFlag】。");
		*/
	    return "01";
	}
	
	//押品系统字段与零售系统字段映射
	public static String parseElement(String name){
		if(name.toUpperCase().equals("COUNTRY")) return "CountryCode";
		return name;
	}
	
	//押品系统返回的要素新建或更新本地押品记录
	public String updateCollInfo(JBOTransaction tx) throws Exception{
		this.setTx(tx);
		BusinessObjectManager bom = this.getBusinessObjectManager();
	
		BusinessObject inputObject = this.getInputParameters();
		String keyInfo = inputObject.getString("assetkeyinfo");  //押品系统返回的信息 clrNo@clrName@clrType@clrValue
		String flag = inputObject.getString("flag"); //0新增，1更新
		String asd = inputObject.getString("asd"); //0新增，1更新
		int i = keyInfo.split("@").length;
		if(flag.equals("0")){//按照录入的新增数据，且把接口返回的要素更新至该新建押品中
			JSONObject assetdata = (JSONObject)this.inputParameter.getValue("assetbo");  //本地录入的押品信息
			JSONObject data = (JSONObject)assetdata.get(0).getValue();
			BusinessObject assetObject = ObjectWindowHelper.createBusinessObject_JSON(data);
			ASDataObject dataObject=Component.getDataObject(asd);
			ALSBusinessProcess bp = ALSBusinessProcess.createBusinessProcess(null, dataObject, bom);
			assetObject=bp.convertBusinessObject(assetObject);
			assetObject.setAttributeValue("CLRSerialNo", keyInfo.split("@")[0]);
			assetObject.setAttributeValue("AssetName", keyInfo.split("@")[1]);
			assetObject.setAttributeValue("AssetType", keyInfo.split("@")[2]);
			if(i == 4){
				assetObject.setAttributeValue("ConfirmValue", Double.parseDouble(keyInfo.split("@")[3]));
			}
			assetObject.generateKey();
			String assetSerialNo = assetObject.getKeyString();
			
			//新建Asset_Info和押品表
			CollateralTemplate ct = new CollateralTemplate();
			String jboName = ct.getJBOName(keyInfo.split("@")[2]);//获取该押品类型对应的jbo
			if(!jboName.equals("")){
				BusinessObject bo = assetObject.getBusinessObject(jboName);
				String boNo = bo.getKeyString();
				if(StringX.isEmpty(boNo)){
					bo.setKey(assetSerialNo);
				}
				bom.updateBusinessObject(bo);
			}
			bom.updateBusinessObject(assetObject);
			bom.updateDB();
			return assetSerialNo;
		}
		else if(flag.equals("1")){//将接口返回的要素更新至该押品
			//assetObject.changeState(StateBizObject.STATE_CHANGED);
			BusinessObject asset = bom.keyLoadBusinessObject("jbo.app.ASSET_INFO", inputObject.getString("AssetSerialNo"));
			//asset.setAttributeValue("CLRSerialNo", keyInfo.split("@")[0]);
			asset.setAttributeValue("AssetName", keyInfo.split("@")[1]);
			asset.setAttributeValue("AssetType", keyInfo.split("@")[2]);
			if(i == 4){
				asset.setAttributeValue("ConfirmValue", Double.parseDouble(keyInfo.split("@")[3]));
			}
			bom.updateBusinessObject(asset);
			bom.updateDB();
			return inputObject.getString("AssetSerialNo");
		}
		else return "";
	}
}
