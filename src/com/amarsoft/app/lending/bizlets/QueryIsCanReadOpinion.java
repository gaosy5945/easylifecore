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
 *功能：查询是否可以查看签署意见的详细信息
 */
public class QueryIsCanReadOpinion extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{	
		String userID=(String)this.getAttribute("UserID");
		String flowSerialNo=(String)this.getAttribute("FlowSerialNo");
		String flag = "false";
		//因为存量数据没有BA，并且新增的申请如果是通过审核也会有BC,所以先通过BC表查该笔业务是不是经营性贷款（productType3 = ‘02’ 是）
		String productType3 = Sqlca.getString(new SqlObject("select PPL.ProductType3 from FLOW_OBJECT FO,BUSINESS_CONTRACT BC,PRD_PRODUCT_LIBRARY PPL where FO.ObjectType = 'jbo.app.BUSINESS_APPLY' and FO.ObjectNo = BC.ApplySerialNo and BC.BusinessType = PPL.ProductID and FO.FlowSerialNo = :FlowSerialNo").setParameter("FlowSerialNo", flowSerialNo));
		//如果通过BC表查不到该笔业务的信息说明这笔业务肯定不是存量数据那就一定有BA，就可以通过BA查询是不是经营性贷款（productType3 = ‘02’ 是）
		if(productType3 == null){
			productType3 = Sqlca.getString(new SqlObject("select PPL.ProductType3 from FLOW_OBJECT FO,BUSINESS_APPLY BA,PRD_PRODUCT_LIBRARY PPL where FO.ObjectType = 'jbo.app.BUSINESS_APPLY' and FO.ObjectNo = BA.SerialNo and BA.BusinessType = PPL.ProductID and FO.FlowSerialNo = :FlowSerialNo").setParameter("FlowSerialNo", flowSerialNo));
			//如果都查不到说明该业务不是贷款申请，则不需要控制
			if(productType3 == null) productType3 = "";
		}
		if("02".equals(productType3)){
			//如果是经营性贷款则需判断该用户是否有权限（一、二级机构的审批、批复意见登记岗、分行主管行长和一级机构的审查岗可以看）
			ASResultSet sr = Sqlca.getResultSet(new SqlObject("select * from USER_INFO UI,USER_ROLE UR,ORG_INFO OI where UI.USERID = UR.USERID and UI.BELONGORG = OI.ORGID and "
					+ "((UR.ROLEID IN ('PLBS0008','PLBS0034','PLBS0031') AND OI.ORGLEVEL IN ('1','2')) or (UR.ROLEID = 'PLBS0006' AND OI.ORGLEVEL ='1')) "
					+ "AND UI.USERID = :USERID").setParameter("USERID", userID));
			if(sr.next()){
				flag = "true";
			}
			sr.getStatement().close();
		}else{
			flag = "true";
		}
		return flag;
	}

}
