/**
 * 
 */
package com.amarsoft.app.als.assetTransfer.action;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import com.amarsoft.app.als.assetTransfer.model.ProjectAdjustHistory;
import com.amarsoft.app.als.assetTransfer.model.ProjectAssetRela;
import com.amarsoft.app.als.assetTransfer.model.ProjectInfo;
import com.amarsoft.app.als.assetTransfer.util.AssetProjectCodeConstant;
import com.amarsoft.app.als.credit.common.model.CreditConst;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.DateX;
import com.amarsoft.are.lang.StringX;

/**
 * ������	�ʲ�ɸѡ����
 * @author xyli & fengcr
 * @2014-12-31
 */
public class AssetFilterAction {
	
	private String projectNo;
	
	private String serialNos;
	
	private String serialNos2;
	
	private String outRate;
	
	private String outRateAdjustType;
	
	private String userId;
	
	private String orgId;
	
	private String managerFeeRate;
	
	private String otherFeeRate;
	/**
	 * ������ɸѡ
	 * @param tx
	 * @return
	 * @throws Exception
	 */
	public String filter(JBOTransaction tx) throws Exception{
		String result = "";
		
		BizObjectManager bmBD = JBOFactory.getBizObjectManager(CreditConst.BD_JBOCLASS);
		tx.join(bmBD);
		
		//ͨ����Ŀ��ˮ�Ų�ѯ����Ŀ�Ƿ����
		ProjectInfo info = new ProjectInfo(tx,projectNo);
		BizObject boPPI = info.getBizObject();
		if(null != boPPI){
			if(!StringX.isEmpty(serialNos)){
				String[] strs = serialNos.split("@");//�����ˮ��
				for(String bdSerialNo : strs){
					//��ѯ�����Ϣ
					BizObject boBD = bmBD.createQuery("SERIALNO=:bdSerialNo").setParameter("bdSerialNo", bdSerialNo).getSingleResult(false);
					if(null != boBD){
						ProjectAssetRela rela = new ProjectAssetRela(tx);
						rela.newObject();//�½�����
						Map<String,Object> map = new HashMap<String,Object>();
						map.put("ObjectNo", bdSerialNo);
						map.put("OBJECTTYPE", "jbo.app.BUSINESS_DUEBILL");
						map.put("CONTRACTSERIALNO", boBD.getAttribute("CONTRACTSERIALNO").getString());
						map.put("LOANACCOUNTNO", boBD.getAttribute("LOANACCOUNTNO").getString());
						map.put("ACTUALBUSINESSRATE", boBD.getAttribute("ACTUALBUSINESSRATE").getString());
						map.put("PROJECTSERIALNO", projectNo);
						map.put("BUSINESSSUM", boBD.getAttribute("BUSINESSSUM").getDouble());
						map.put("EXECUTERATE", boBD.getAttribute("ACTUALBUSINESSRATE").getDouble());//������
						map.put("OPERATEORGID", boBD.getAttribute("OPERATEORGID").getString());
						map.put("Status", AssetProjectCodeConstant.ProjectAssetStatus_01);
						
						rela.setAttributesValue(map);//��������ֵ
						rela.saveObject();//�������
						
					}
				}
				
				//��¼�ʲ�������¼
				ProjectAdjustHistory adjust = new ProjectAdjustHistory(tx, "");
				Map<String,Object> map = new HashMap<String,Object>();
				map.put("OBJECTNO", projectNo);
				map.put("OBJECTTYPE", "jbo.app.BUSINESS_DUEBILL");
				map.put("ADJUSTTYPE", AssetProjectCodeConstant.AdjustType_010);
				map.put("ADJUSTUSERID", userId);
				map.put("ADJUSTORGID", orgId);
				map.put("ADJUSTDATE", DateX.format(new Date()));
				adjust.setAttributesValue(map);
				adjust.save();
			}
		}else{
			result = "����ʧ��,���ȱ�����Ŀ������Ϣ";
		}
		
		return result;
	}
	
	public String filter2(JBOTransaction tx) throws Exception{
		String result = "";
		
		BizObjectManager bmBD = JBOFactory.getBizObjectManager(CreditConst.BD_JBOCLASS);
		tx.join(bmBD);

		if(!StringX.isEmpty(serialNos)){
			String[] strs = serialNos.split("@");//�����ˮ��
			for(String bdSerialNo : strs){
				//��ѯ�����Ϣ
				BizObject boBD = bmBD.createQuery("SERIALNO=:bdSerialNo").setParameter("bdSerialNo", bdSerialNo).getSingleResult(false);
				if(null != boBD){
					ProjectAssetRela rela = new ProjectAssetRela(tx);
					rela.newObject();//�½�����
					Map<String,Object> map = new HashMap<String,Object>();
					map.put("ObjectNo", bdSerialNo);
					map.put("OBJECTTYPE", "jbo.app.BUSINESS_DUEBILL");
					map.put("CONTRACTSERIALNO", boBD.getAttribute("CONTRACTSERIALNO").getString());
					map.put("LOANACCOUNTNO", boBD.getAttribute("LOANACCOUNTNO").getString());
					map.put("ACTUALBUSINESSRATE", boBD.getAttribute("ACTUALBUSINESSRATE").getString());
					map.put("BUSINESSSUM", boBD.getAttribute("BUSINESSSUM").getDouble());
					map.put("EXECUTERATE", boBD.getAttribute("ACTUALBUSINESSRATE").getDouble());//������
					map.put("OPERATEORGID", boBD.getAttribute("OPERATEORGID").getString());
					map.put("Status", AssetProjectCodeConstant.ProjectAssetStatus_01);
					
					rela.setAttributesValue(map);//��������ֵ
					rela.saveObject();//�������
					
				}
			}
		}
		return result;
	}
	
	public String submit(JBOTransaction tx) throws Exception{
		String result = "false";
		if(!StringX.isEmpty(serialNos)){
			String[] strs = serialNos.split("@");
			for(String serialNo : strs){
				ProjectAssetRela rela = new ProjectAssetRela(tx,projectNo);
				Map<String,Object> map = new HashMap<String, Object>();
				map.put("PROJECTSERIALNO", serialNo);
				rela.setAttributesValue(map);
				rela.saveObject();
			}
			result = "true";
		}
		return result;
	}
	/**
	 * �������ʲ��û�
	 * @param tx
	 * @return
	 * @throws Exception
	 */
	public String assetReplacement(JBOTransaction tx) throws Exception{
		String result = "";
		
		BizObjectManager bmBD = JBOFactory.getBizObjectManager(CreditConst.BD_JBOCLASS);
		tx.join(bmBD);
		
		//1.ɾ�����û����ʲ�
		if(serialNos.endsWith("@")){
			serialNos = serialNos.substring(0, serialNos.length() - 1);
		}
		serialNos = serialNos.replaceAll("@", "','");
		
		ProjectAssetRela rela = new ProjectAssetRela(tx);
		rela.delObject(serialNos);
		
		//2.�����û����ʲ�
		String[] strs = serialNos2.split("@");//�����ˮ��
		for(String bdSerialNo : strs){
			//��ѯ�����Ϣ
			BizObject boBD = bmBD.createQuery("SERIALNO=:bdSerialNo").setParameter("bdSerialNo", bdSerialNo).getSingleResult(false);
			if(null != boBD){
				ProjectAssetRela assetRela = new ProjectAssetRela(tx);
				assetRela.newObject();//�½�����
				Map<String,Object> map = new HashMap<String,Object>();
				map.put("PROJECTNO", projectNo);
				map.put("BCSERIALBNO", boBD.getAttribute("RELATIVESERIALNO2").getString());
				map.put("LOANNO", bdSerialNo);
				map.put("CURRENCY", boBD.getAttribute("BUSINESSCURRENCY").getString());
				map.put("BUSINESSSUM", boBD.getAttribute("BUSINESSSUM").getDouble());
				map.put("EXECUTERATE", boBD.getAttribute("ACTUALBUSINESSRATE").getDouble());//������
				map.put("USERID", boBD.getAttribute("OPERATEUSERID").getString());
				map.put("ORGID", boBD.getAttribute("OPERATEORGID").getString());
				map.put("Status", AssetProjectCodeConstant.AssetProjectStatus_010);
				assetRela.setAttributesValue(map);//��������ֵ
				assetRela.saveObject();//�������
			}
		}
		
		//��¼�ʲ�������¼
		ProjectAdjustHistory adjust = new ProjectAdjustHistory(tx, "");
		Map<String,Object> map = new HashMap<String,Object>();
		map.put("OBJECTNO", projectNo);
		map.put("OBJECTTYPE", "AssetProject");
		map.put("ADJUSTTYPE", AssetProjectCodeConstant.AdjustType_020);
		map.put("ADJUSTUSERID", userId);
		map.put("ADJUSTORGID", orgId);
		map.put("ADJUSTDATE", DateX.format(new Date()));
		adjust.setAttributesValue(map);
		adjust.save();
		
		return result;
	}
	
	/**
	 * ������ɾ��
	 * @param tx
	 * @return
	 * @throws Exception
	 */
	public String del(JBOTransaction tx) throws Exception{
		String result = "false";
		if(!StringX.isEmpty(serialNos)){
			if(serialNos.endsWith("@")){
				serialNos = serialNos.substring(0, serialNos.length() - 1);
			}
			serialNos = serialNos.replaceAll("@", "','");
			
			ProjectAssetRela rela = new ProjectAssetRela(tx);
			boolean flag = rela.delObject(serialNos);
			if(flag){
				result = "true";
			}
		}
		return result;
	}
	
	/**
	 * ������ת����������
	 * @param tx
	 * @return
	 * @throws Exception
	 */
	public String setRate(JBOTransaction tx) throws Exception{
		BizObjectManager bmBD = JBOFactory.getBizObjectManager(CreditConst.BD_JBOCLASS);
		tx.join(bmBD);
		String result = "false";
		ProjectInfo info = new ProjectInfo(tx,projectNo);
		String projectType = info.getBizObject().getAttribute("PROJECTTYPE").toString();
		if(!StringX.isEmpty(serialNos)){
			String[] strs = serialNos.split("@");
			for(String serialNo : strs){
				ProjectAssetRela rela = new ProjectAssetRela(tx,serialNo);
				String objectNo = rela.getBizObject().getAttribute("OBJECTNO").toString();
				
				BizObject boBD = bmBD.createQuery("SERIALNO=:bdSerialNo").setParameter("bdSerialNo", objectNo).getSingleResult(false);
				Double actualBusinessRate = boBD.getAttribute("ACTUALBUSINESSRATE").getDouble();
				Double outRated = Double.parseDouble(outRate);
				if(managerFeeRate == null){
					managerFeeRate = "0.0";
				}
				Double managerFeeRated = Double.parseDouble(managerFeeRate);
				if(otherFeeRate == null){
					otherFeeRate = "0.0";
				}
				Double otherFeeRated = Double.parseDouble(otherFeeRate);
				//�ʲ�ת����Ŀ
				if("0201".equals(projectType)){
					if(outRated > actualBusinessRate - managerFeeRated - otherFeeRated){
						result = "�ʲ�ת����Ŀ���ʲ����Ϊ"+serialNo+"��ת���������ò��ô��ڴ���ִ�����ʡ�������ʡ���������";
						break;
					}
				//�ʲ�֤ȯ����Ŀ
				}else if("0203".equals(projectType)){
					if(actualBusinessRate < outRated){
						result = "�ʲ�֤ȯ����Ŀ���ʲ����Ϊ"+serialNo+"��ת���������ò��ô��ڴ���ִ������";
						break;
					}
				}else{
					
				}
				
				Map<String,Object> map = new HashMap<String, Object>();
				map.put("TRANSFERRATE", outRate);
				rela.setAttributesValue(map);
				rela.saveObject();
				
				bmBD.createQuery("update o set LOANRATEREPRICETYPE=:outRateAdjustType where SerialNo=:serialNo")
				.setParameter("outRateAdjustType", this.outRateAdjustType)
				.setParameter("serialNo",objectNo).executeUpdate();
			}
			if("false".equals(result)){
				result = "true";
			}else{
				result = result;
			}
		}
		return result;
	}
	
	/**
	 * ������ת��������������
	 * @param tx
	 * @return
	 * @throws Exception
	 */
	public String batchSetRate(JBOTransaction tx) throws Exception{
		String result = "false";
		if(!StringX.isEmpty(projectNo)){
			ProjectInfo info = new ProjectInfo(tx);
			info.batchSetRate(projectNo, outRate, outRateAdjustType);
			result = "true";
		}
		return result;
	}
	

	public String getProjectNo() {
		return projectNo;
	}

	public void setProjectNo(String projectNo) {
		this.projectNo = projectNo;
	}

	public String getSerialNos() {
		return serialNos;
	}

	public void setSerialNos(String serialNos) {
		this.serialNos = serialNos;
	}

	public String getOutRate() {
		return outRate;
	}

	public void setOutRate(String outRate) {
		this.outRate = outRate;
	}

	public String getOutRateAdjustType() {
		return outRateAdjustType;
	}

	public void setOutRateAdjustType(String outRateAdjustType) {
		this.outRateAdjustType = outRateAdjustType;
	}

	public String getSerialNos2() {
		return serialNos2;
	}

	public void setSerialNos2(String serialNos2) {
		this.serialNos2 = serialNos2;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getOrgId() {
		return orgId;
	}

	public void setOrgId(String orgId) {
		this.orgId = orgId;
	}
	
	public String getManagerFeeRate() {
		return managerFeeRate;
	}

	public void setManagerFeeRate(String managerFeeRate) {
		this.managerFeeRate = managerFeeRate;
	}

	public String getOtherFeeRate() {
		return otherFeeRate;
	}

	public void setOtherFeeRate(String otherFeeRate) {
		this.otherFeeRate = otherFeeRate;
	}
}
