package com.amarsoft.app.edoc;
/**
 *  放款前进行合同打印时更新一下基础利率
 */

import java.util.List;

import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.app.base.util.RateHelper;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;

public class UploadBaseRate {
	
	private String serialNo;
	
	
	public String getSerialNo() {
		return serialNo;
	}

	public void setSerialNo(String serialNo) {
		this.serialNo = serialNo;
	}
	
	public String uploadBaseRate(JBOTransaction tx) throws Exception{
		BizObjectManager bc = JBOFactory.getBizObjectManager("jbo.app.BUSINESS_CONTRACT");
		tx.join(bc);
		BizObjectQuery bcq = bc.createQuery("SerialNo = :SerialNo").setParameter("SerialNo", serialNo);
		BizObject nbcq = bcq.getSingleResult(false);
		
		BizObjectManager ars = JBOFactory.getBizObjectManager("jbo.acct.ACCT_RATE_SEGMENT");
		tx.join(ars);
		BizObjectQuery arsq = ars.createQuery("ObjectType = 'jbo.app.BUSINESS_CONTRACT' and ObjectNo = :ObjectNo and RateType = '01' and RateMode = '1'")
				.setParameter("ObjectNo", serialNo);
		BizObject narsq = arsq.getSingleResult(false);
		List<BizObject> arsqboList = arsq.getResultList(false);
		for(BizObject arbo:arsqboList)
		{
			String currency = nbcq.getAttribute("BUSINESSCURRENCY").getString();
			String baseRateType = narsq.getAttribute("BASERATETYPE").getString();
			if("".equals(baseRateType) || baseRateType == null){
				baseRateType = "205";
			}
			String termUnit = DateHelper.TERM_UNIT_MONTH;
			int  term = nbcq.getAttribute("BUSINESSTERM").getInt();
			int termday = nbcq.getAttribute("BUSINESSTERMDAY").getInt();
			term = term + termday/30 + (termday%30 > 0 ? 1 : 0);
			String effectDate = DateHelper.getBusinessDate();
			double baseRate = RateHelper.getBaseRate(currency, 360, baseRateType, "01", termUnit, term, effectDate);
			//double baseRate = BaseRateConfig.getBaseRate(nbcq.getAttribute("BUSINESSCURRENCY").getString(), 360, narsq.getAttribute("BASERATETYPE").getString(), "01", nbcq.getAttribute("BUSINESSTERMUNIT").getString(), nbcq.getAttribute("BUSINESSTERM").getString(), DateHelper.getToday());
			double businessRate = (1+narsq.getAttribute("RATEFLOAT").getDouble()/100)*baseRate;
			ars.createQuery("UPDATE O SET BUSINESSRATE = :BUSINESSRATE,BASERATE = :BASERATE WHERE SERIALNO = :SERIALNO")
			.setParameter("BUSINESSRATE", businessRate)
			.setParameter("BASERATE", baseRate)
			.setParameter("SERIALNO", narsq.getAttribute("SERIALNO").getString()).executeUpdate();
		}
		return "true@基准利率更新成功，请在合同详情中查看";
	}
	
}





