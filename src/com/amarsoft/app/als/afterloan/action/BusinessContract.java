package com.amarsoft.app.als.afterloan.action;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;

public class BusinessContract {

	//��ѯ��Ӫ�Դ����ݵĴ�����Ƶ��    ����SerialNo��Inspect_Record.SerialNo,ͨ������¼��ѯ��ͬ������Ƶ��
	public static String selectCheckFrequency(String SerialNo) throws Exception
	{
		BizObjectQuery q =  JBOFactory.getFactory().getManager("jbo.al.INSPECT_RECORD").createQuery("SerialNo=:IRSerialNo");
		q.setParameter("IRSerialNo", SerialNo);
		BizObject boc1 = q.getSingleResult(false);
		String sDuebillSerialNo = "";
		if(boc1!=null){
			sDuebillSerialNo = boc1.getAttribute("ObjectNo").toString();
		}
		if(sDuebillSerialNo==null) sDuebillSerialNo="";
		
		BizObject boc2 = JBOFactory.getFactory().getManager("jbo.acct.ACCT_LOAN").createQuery("SerialNo=:SerialNo").
				setParameter("SerialNo", sDuebillSerialNo).getSingleResult(false);

		String sCHECKFREQUENCY = "";
		if(boc2!=null)
		{
			BizObject boc3 = JBOFactory.getFactory().getManager("jbo.app.BUSINESS_CONTRACT").createQuery("SerialNo=:SerialNo").
					setParameter("SerialNo", boc2.getAttribute("ContractSerialNo").getString()).getSingleResult(false);
			
			sCHECKFREQUENCY = boc3.getAttribute("CHECKFREQUENCY").toString();
		}
		return sCHECKFREQUENCY;
	}
	
	public static String selectCheckFrequencyfromFLow(String SerialNo) throws Exception
	{
		String sFLowSerialNo = SerialNo;
			
		BizObjectQuery q =  JBOFactory.getFactory().getManager("jbo.flow.FLOW_OBJECT").createQuery("FlowSerialNo=:FLOWSERIALNO and ObjectType like 'jbo.al.INSPECT_RECORD%'");
		q.setParameter("FLOWSERIALNO", sFLowSerialNo);
		BizObject fo = q.getSingleResult(false);
		String sInspectSerialNo = "";
		String sFlowObjectType = "";
		if(fo!=null){
			sInspectSerialNo = fo.getAttribute("ObjectNo").toString();
			sFlowObjectType = fo.getAttribute("ObjectType").toString();
		}
		if(sInspectSerialNo==null) sInspectSerialNo="";
		if(sFlowObjectType==null) sFlowObjectType="";
		
		String sObjectNo = "";
		BizObjectQuery query =  JBOFactory.getFactory().getManager("jbo.al.INSPECT_RECORD").createQuery("SerialNo=:IRSerialNo");
		query.setParameter("IRSerialNo", sInspectSerialNo);
		BizObject ir = query.getSingleResult(false);
		if(ir!=null){
			sObjectNo = ir.getAttribute("ObjectNo").toString();
		}
		if(sObjectNo==null) sObjectNo="";//��ݱ�ţ�������Ӫ������飩
//		if(sFlowObjectType.equals("jbo.al.INSPECT_RECORD")){
//			sContractNoSerialNo = sObjectNo;
//		}else if(sFlowObjectType.equals("jbo.al.INSPECT_RECORD_02")){//��ʱobjectNoΪ��ݱ��
//			BizObject bd = JBOFactory.getFactory().getManager("jbo.app.BUSINESS_DUEBILL").createQuery("SerialNo=:SerialNo").
//					setParameter("SerialNo", sObjectNo).getSingleResult(false);
//			if(bd!=null){
//				sObjectNo = bd.getAttribute("CONTRACTSERIALNO").toString();
//				sContractNoSerialNo = sObjectNo;
//			}
//		}
//		if(sContractNoSerialNo==null) sContractNoSerialNo="";
		
		BizObject boc2 = JBOFactory.getFactory().getManager("jbo.app.BUSINESS_DUEBILL").createQuery("SerialNo=:SerialNo").
				setParameter("SerialNo", sObjectNo).getSingleResult(false);

		String sCHECKFREQUENCY = "";
		if(boc2!=null)
		{
			BizObject boc3 = JBOFactory.getFactory().getManager("jbo.app.BUSINESS_CONTRACT").createQuery("SerialNo=:SerialNo").
					setParameter("SerialNo", boc2.getAttribute("ContractSerialNo").getString()).getSingleResult(false);
			
			sCHECKFREQUENCY = boc3.getAttribute("CHECKFREQUENCY").toString();
		}
		return sCHECKFREQUENCY;
	}

}
