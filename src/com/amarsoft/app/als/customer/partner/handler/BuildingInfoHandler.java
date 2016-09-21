package com.amarsoft.app.als.customer.partner.handler;

import com.amarsoft.app.als.customer.model.CustomerConst;
import com.amarsoft.app.als.customer.partner.model.PartnerProjectInfo;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.awe.dw.handler.impl.CommonHandler;
import com.amarsoft.awe.util.DBKeyHelp;
/**
 * ֻ������Ŀ����ʱ��������¥�̲��õ��˴�����
 * @author Administrator
 *
 */
public class BuildingInfoHandler extends CommonHandler {

	protected void initDisplayForAdd(BizObject bo) throws Exception {
		super.initDisplayForAdd(bo);
		if(StringX.isEmpty(bo.getAttribute("SerialNo"))){
			bo.setAttributeValue("SerialNo", DBKeyHelp.getSerialNo("BUILDING_INFO", "SerialNo"));
		}
	}
	
	/**
	 * 	����������ϵ
	 */
	protected void afterInsert(JBOTransaction tx, BizObject bo)throws Exception {
		super.afterInsert(tx, bo);
		//�½�������ϵ
		new PartnerProjectInfo(asPage.getParameter("ProjectNo")).initProjectRelative(tx, CustomerConst.PARTNER_RELATIVE_TYPE_6, bo.getAttribute("SerialNo").getString()
					, bo.getAttribute("BuildingName").getString());
	}
}
