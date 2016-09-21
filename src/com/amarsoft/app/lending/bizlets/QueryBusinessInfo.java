package com.amarsoft.app.lending.bizlets;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.app.als.credit.contract.action.AddContractInfo;
import com.amarsoft.app.als.credit.putout.action.AddPutOutInfo;
import com.amarsoft.app.workflow.config.FlowConfig;
import com.amarsoft.app.workflow.util.FlowHelper;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.DateX;
import com.amarsoft.biz.bizlet.Bizlet;
/**
 * 
 * @author T-zhangwl
 *功能：查询任务的详细信息
 */
public class QueryBusinessInfo extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{	
		String userID=(String)this.getAttribute("UserID");
		String flag = "false";
		ASResultSet sr = Sqlca.getResultSet(new SqlObject("select * from USER_INFO UI,USER_ROLE UR,ORG_INFO OI where UI.USERID = UR.USERID and UI.BELONGORG = OI.ORGID and "
				+ "((UR.ROLEID IN ('PLBS0008','PLBS0034','PLBS0031') AND OI.ORGLEVEL IN ('1','2')) or (UR.ROLEID = 'PLBS0006' AND OI.ORGLEVEL ='1')) "
				+ "AND UI.USERID = :USERID").setParameter("USERID", userID));
		if(sr.next()){
			flag = "true";
		}
		sr.getStatement().close();

		return flag;
	}

}
