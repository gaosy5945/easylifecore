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
 *���ܣ���ѯ�Ƿ���Բ鿴ǩ���������ϸ��Ϣ
 */
public class QueryIsCanReadOpinion extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{	
		String userID=(String)this.getAttribute("UserID");
		String flowSerialNo=(String)this.getAttribute("FlowSerialNo");
		String flag = "false";
		//��Ϊ��������û��BA���������������������ͨ�����Ҳ����BC,������ͨ��BC���ñ�ҵ���ǲ��Ǿ�Ӫ�Դ��productType3 = ��02�� �ǣ�
		String productType3 = Sqlca.getString(new SqlObject("select PPL.ProductType3 from FLOW_OBJECT FO,BUSINESS_CONTRACT BC,PRD_PRODUCT_LIBRARY PPL where FO.ObjectType = 'jbo.app.BUSINESS_APPLY' and FO.ObjectNo = BC.ApplySerialNo and BC.BusinessType = PPL.ProductID and FO.FlowSerialNo = :FlowSerialNo").setParameter("FlowSerialNo", flowSerialNo));
		//���ͨ��BC��鲻���ñ�ҵ�����Ϣ˵�����ҵ��϶����Ǵ��������Ǿ�һ����BA���Ϳ���ͨ��BA��ѯ�ǲ��Ǿ�Ӫ�Դ��productType3 = ��02�� �ǣ�
		if(productType3 == null){
			productType3 = Sqlca.getString(new SqlObject("select PPL.ProductType3 from FLOW_OBJECT FO,BUSINESS_APPLY BA,PRD_PRODUCT_LIBRARY PPL where FO.ObjectType = 'jbo.app.BUSINESS_APPLY' and FO.ObjectNo = BA.SerialNo and BA.BusinessType = PPL.ProductID and FO.FlowSerialNo = :FlowSerialNo").setParameter("FlowSerialNo", flowSerialNo));
			//������鲻��˵����ҵ���Ǵ������룬����Ҫ����
			if(productType3 == null) productType3 = "";
		}
		if("02".equals(productType3)){
			//����Ǿ�Ӫ�Դ��������жϸ��û��Ƿ���Ȩ�ޣ�һ��������������������������ǼǸڡ����������г���һ�����������ڿ��Կ���
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
