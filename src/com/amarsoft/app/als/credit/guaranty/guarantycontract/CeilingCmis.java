package com.amarsoft.app.als.credit.guaranty.guarantycontract;

import java.util.List;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.lang.StringX;

/**
 * ����ת��
 * @author wur
 *
 */
public class CeilingCmis{
	//���ݺ�ͬ��ŵõ�ѺƷ��ˮ��                                                                                                                                                                                                                                                  
	public static String getAssetSerialno(String sGCSerialNo){      
		if( null == sGCSerialNo || "".equals(sGCSerialNo)) return "";
		StringBuffer AssetSerialno = new StringBuffer();
		String AssetSerialnos = "";
		try{
			BizObjectManager bm=JBOFactory.getBizObjectManager("jbo.guaranty.GUARANTY_RELATIVE");
			List<BizObject> lst=bm.createQuery("GCSERIALNO=:GCSERIALNO").setParameter("GCSERIALNO", sGCSerialNo).getResultList(false); 
			for(BizObject bo:lst){
					AssetSerialno.append(bo.getAttribute("ASSETSERIALNO").getString()).append(",");
			}
			
			if(StringX.isEmpty(AssetSerialno.toString())||"null".equals(AssetSerialno.toString())||"null"==AssetSerialno.toString()){
			}else{
				AssetSerialnos = AssetSerialno.toString().substring(0,AssetSerialno.toString().length()-1);
				if(StringX.isEmpty(AssetSerialnos) || AssetSerialnos=="null") AssetSerialnos = "";
			}

		}catch(Exception e){
			e.printStackTrace();
		}
		return AssetSerialnos;
	}
	
	//���ݺ�ͬ��ŵõ�����ծȨ���                                                                                                                                                                                                                                                  
		public static double getGntCrRtAmt(String sGCSerialNo){                                                                                                                                                                                                                            
			if( null == sGCSerialNo || "".equals(sGCSerialNo)) return 0.0;                                                                                                                                                                                                                    
			double sGntCrRtAmt = 0.0;    
			try{   
				BizObjectManager bm=JBOFactory.getBizObjectManager("jbo.app.APPLY_RELATIVE");
				BizObject bo = bm.createQuery(" O.objecttype='jbo.guaranty.GUARANTY_CONTRACT' and O.objectno=:GCSerialNo and O.RelativeType='05' ").setParameter("GCSerialNo", sGCSerialNo).getSingleResult(false); 
				if(bo==null){
					sGntCrRtAmt = 0.0;
				} else {
					sGntCrRtAmt = bo.getAttribute("RELATIVEAMOUNT").getDouble();
				}              
			}catch(Exception e){                                                                                                                                                                                                                                                             
				e.printStackTrace();                                                                                                                                                                                                                                                           
			}                                                                                                                                                                                                                                                                                
			return sGntCrRtAmt;                                                                                                                                                                                                                                                              
		} 
		
		//��ȡ����ʶ��Ҫ��
		public static String getAttribute4(String assettype) throws Exception
		{
			String result = "";
			BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.sys.CODE_LIBRARY");
			BizObjectQuery boq = bm.createQuery("select ATTRIBUTE4 from O where  codeno='AssetType' and Itemno=:AssetType");
			boq.setParameter("AssetType", assettype);
			BizObject bo = boq.getSingleResult(false);
			if(bo != null)
			{
				result = bo.getAttribute("ATTRIBUTE4").getString();
			}		
			return result;
		}

		//��ȡ����ʶ��Ҫ��
		public static String getAttribute5(String assettype) throws Exception
		{
			String result = "";
			BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.sys.CODE_LIBRARY");
			BizObjectQuery boq = bm.createQuery("select ATTRIBUTE5 from O where  codeno='AssetType' and Itemno=:AssetType");
			boq.setParameter("AssetType", assettype);
			BizObject bo = boq.getSingleResult(false);
			if(bo != null)
			{
				result = bo.getAttribute("ATTRIBUTE5").getString();
			}		
			return result;
		}
	}

	