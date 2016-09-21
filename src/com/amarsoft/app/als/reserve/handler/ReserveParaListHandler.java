/**
 * 
 */
package com.amarsoft.app.als.reserve.handler;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.awe.dw.handler.impl.CommonHandler;


/**
 * ��������ϼ����������	
 * @author xyli
 * @2014-5-16
 */
public class ReserveParaListHandler extends CommonHandler {
	
	@Override
	protected void beforeInsert(JBOTransaction tx, BizObject bo)throws Exception {
		String customerType = asPage.getParameter("CustomerType");
		bo.setAttributeValue("CustomerType", customerType);
	}
	
}
