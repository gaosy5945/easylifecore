package com.amarsoft.app.als.sys.role.handler;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.awe.dw.handler.impl.CommonHandler;

public class RoleManageHandler extends CommonHandler{
	
	protected void beforeDelete(JBOTransaction tx, BizObject bo) throws Exception{
		String roleID = bo.getAttribute("RoleID").toString();
		int i= JBOFactory.getBizObjectManager("jbo_sys.ROLE_RIGHT", tx)
				.createQuery("delete from O where RoleID =:RoleID ")
				.setParameter("RoleID", roleID)
				.executeUpdate();
	}

}
