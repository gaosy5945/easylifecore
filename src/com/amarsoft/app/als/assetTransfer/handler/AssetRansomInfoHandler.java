/**
 * 
 */
package com.amarsoft.app.als.assetTransfer.handler;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

import com.amarsoft.app.als.assetTransfer.model.ProjectAssetRela;
import com.amarsoft.app.als.assetTransfer.util.AssetProjectCodeConstant;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.awe.dw.handler.impl.CommonHandler;

/**
 * ������	�ʲ����
 * @author xyli
 * @2014-4-23
 */
public class AssetRansomInfoHandler extends CommonHandler {

	@Override
	protected void initDisplayForAdd(BizObject bo) throws Exception {
		String serialNo = asPage.getParameter("SerialNo");
		String projectNo = asPage.getParameter("ProjectNo");
		String relaSerialNos = asPage.getParameter("relaSerialNos");
		if(relaSerialNos.endsWith("@")){
			relaSerialNos = relaSerialNos.substring(0, relaSerialNos.length() - 1);
		}
		relaSerialNos = relaSerialNos.replaceAll("@", "','");
		
		ProjectAssetRela rela = new ProjectAssetRela(null);
		List<BizObject> list = rela.getRelaList(relaSerialNos);
		
		Set<String> orgs = new HashSet<String>();//�漰������
		double totalSum = 0.0;//�ʲ���ģ�ϼƣ��ۺ�����ң�
		for(BizObject biz : list){
			orgs.add(biz.getAttribute("ORGID").getString());
			//String currency = biz.getAttribute("CURRENCY").getString();
			double businessSum = biz.getAttribute("BUSINESSSUM").getDouble();
			//TODO ����ת��
			totalSum =+ businessSum;
		}
		
		bo.setAttributeValue("SERIALNO", serialNo);
		bo.setAttributeValue("PROJECTNO", projectNo);
		bo.setAttributeValue("BUSINESSCOUNT", list.size());
		bo.setAttributeValue("ORGCOUNT", orgs.size());
		bo.setAttributeValue("ASSETTOTAL", totalSum);
	}
	
	@Override
	protected void afterInsert(JBOTransaction tx, BizObject bo)throws Exception {
		String relaSerialNos = asPage.getParameter("relaSerialNos");
		//����ص��ʲ�״̬����Ϊ����ء�
		if(relaSerialNos.endsWith("@")){
			relaSerialNos = relaSerialNos.substring(0, relaSerialNos.length() - 1);
		}
		relaSerialNos = relaSerialNos.replaceAll("@", "','");
		
		ProjectAssetRela rela = new ProjectAssetRela(tx);
		rela.changeStatus(relaSerialNos, AssetProjectCodeConstant.AssetRelaStatus_030);
	}
	
	
}
