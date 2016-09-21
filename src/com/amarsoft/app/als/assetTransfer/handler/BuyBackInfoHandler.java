/**
 * 
 */
package com.amarsoft.app.als.assetTransfer.handler;

import com.amarsoft.app.als.assetTransfer.model.ProjectInfo;
import com.amarsoft.app.als.assetTransfer.util.AssetProjectCodeConstant;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.awe.dw.handler.impl.CommonHandler;

/**
 * ������	�ʲ��ع�
 * @author xyli
 * @2014-4-25
 */
public class BuyBackInfoHandler extends CommonHandler {

	@Override
	protected void initDisplayForAdd(BizObject bo) throws Exception {
		String objectNo = asPage.getParameter("ProjectNo");//��Ŀ���
		
		ProjectInfo info = new ProjectInfo(null,objectNo);
		BizObject boPI = info.getBizObject();
		if(null != boPI){
			bo.setAttributeValue("PROJECTNO", objectNo);//��Ŀ���
			bo.setAttributeValue("ProjectName", boPI.getAttribute("ProjectName").getString());//��Ŀ����
			bo.setAttributeValue("ProjectType", boPI.getAttribute("ProjectType").getString());//��Ŀ����
			bo.setAttributeValue("ProjectSum", boPI.getAttribute("ProjectSum").getDouble());//��Ŀ��ǰ���
			bo.setAttributeValue("BuyBackSum", boPI.getAttribute("BuyBackSum").getDouble());//�ع����
			bo.setAttributeValue("BuyBackDate", boPI.getAttribute("BuyBackDate").getString());//�ع�����
			bo.setAttributeValue("OtherCondition", boPI.getAttribute("OtherCondition").getString());//�����ع�����
			bo.setAttributeValue("TransferUserID", boPI.getAttribute("TransferUserID").getString());//���÷�
			bo.setAttributeValue("LaunchBank", boPI.getAttribute("LaunchBank").getString());//��������
			bo.setAttributeValue("TYPE", AssetProjectCodeConstant.BuyBackType_010);//����(�ع�/����)
		}
	}
	
	@Override
	protected void afterInsert(JBOTransaction tx, BizObject bo)throws Exception {
		//�Իع�ʽ�Ĵ���ת����Ŀ���ع��������лع�����Ŀ�׶θ���Ϊ�ѽ���
		String objectNo = asPage.getParameter("ProjectNo");//��Ŀ���
		
		ProjectInfo info = new ProjectInfo(tx);
		info.changeStatus(objectNo, AssetProjectCodeConstant.AssetProjectStatus_040);
	}
	
	
}
