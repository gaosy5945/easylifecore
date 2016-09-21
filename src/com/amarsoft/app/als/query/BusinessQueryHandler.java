package com.amarsoft.app.als.query;

import java.util.List;

import com.amarsoft.app.als.credit.common.model.CreditConst;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.awe.dw.handler.impl.CommonHandler;
/**
 * 快速查询处理类 初始化列表数据
 * @author Administrator
 *
 */
public class BusinessQueryHandler extends CommonHandler {
	
	protected void initDisplayForEdit(BizObject bo) throws Exception {
		super.initDisplayForEdit(bo);

		String businesstype = bo.getAttribute("businesstype").getString();
		String customertype = bo.getAttribute("customertype").getString();
		BizObjectManager bm = JBOFactory.getBizObjectManager(CreditConst.BD_JBOCLASS);
		
		//获取查询条件 这个是增加选择条件后的选择条件
		String whereClause = asDataObject.getJboWhere();
		
		@SuppressWarnings("unchecked")
		List<BizObject> boQuery = bm.createQuery("select o.BUSINESSSUM,o.BUSINESSCURRENCY from o,jbo.app.CUSTOMER_INFO ci where  o.inputorgid like :orgid and " +
				"o.businesstype = :businesstype " +
				" and ci.customertype = :customertype and " + whereClause)
				.setParameter("customertype", customertype).setParameter("businesstype", businesstype)
				.setParameter("orgid",curUser.getOrgID() + "%").getResultList(false);
		long sum = 0;
		if(boQuery.size() != 0){
			for(BizObject b : boQuery){
				long l = b.getAttribute("BUSINESSSUM").getLong();
				String currency = b.getAttribute("BUSINESSCURRENCY").getString();
				double rate = getRate(currency);
				l *= rate;
				sum += l;
			}
		}
		bo.setAttributeValue("sum1", String.valueOf(sum));
		bo.setAttributeValue("sum2", boQuery.size());
	}
	/**
	 * 获取利率
	 * @param currency
	 * @return
	 * @throws JBOException
	 */
	private double getRate(String currency) throws JBOException{
		double d = 0;
		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.sys.ERATE_INFO");
		BizObject boFrom = bm.createQuery("Currency=:Currency").setParameter("Currency", currency).getSingleResult(false);
		d = boFrom.getAttribute("ExchangeValue").getDouble();		
		return d;
	}

}
