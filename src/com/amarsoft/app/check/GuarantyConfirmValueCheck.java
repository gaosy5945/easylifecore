package com.amarsoft.app.check;

import java.util.List;

import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

/**
 * ѺƷ��ֵ���ֵ�Ƿ�һ�¼��
 * @author T-zhangwl
 *
 */

public class GuarantyConfirmValueCheck extends AlarmBiz{

	public Object run(Transaction Sqlca) throws Exception {
		
		List<BusinessObject> baList = (List<BusinessObject>)this.getAttribute("Main");	//��ȡ������Ϣ
		if(baList == null || baList.isEmpty())
			putMsg("���������Ϣδ�ҵ������飡");
		else
		{
			for(BusinessObject ba:baList)
			{
				ASResultSet arrs = Sqlca.getResultSet(new SqlObject("Select GR.AssetSerialNo from GUARANTY_RELATIVE GR,APPLY_RELATIVE AR where "
						+ "AR.ApplySerialNo=:BASerialNo and AR.ObjectNo=GR.GCSerialNo and AR.ObjectType='jbo.guaranty.GUARANTY_CONTRACT' and AR.RelativeType='05'").setParameter("BASerialNo", ba.getString("SerialNo")));
				while(arrs.next()){
					String assetSerialNo = arrs.getStringValue("AssetSerialNo");
					String AEConfirmValue = Sqlca.getString(new SqlObject("select ConfirmValue from ASSET_EVALUATE where AssetSerialNo = :AssetSerialNo order by SerialNo desc").setParameter("AssetSerialNo", assetSerialNo));
					String AIConfirmValue = Sqlca.getString(new SqlObject("select ConfirmValue from ASSET_INFO where SerialNo = :SerialNo").setParameter("SerialNo", assetSerialNo));
					String CLRSerialNo = Sqlca.getString(new SqlObject("select CLRSerialNo from ASSET_INFO where SerialNo = :SerialNo").setParameter("SerialNo", assetSerialNo));
					if(CLRSerialNo == null) CLRSerialNo = "";
					if(AIConfirmValue == null) AIConfirmValue = "";
					//����ѺƷϵͳ���Ϊ�յ���ʾ������δ���ѺƷ��ֵ��ʾ�е�ѺƷϵͳ���Ϊ�գ���ʾ���Ѻ�
					if(StringX.isEmpty(CLRSerialNo)){
						putMsg("ѺƷϵͳ���Ϊ�գ����ȱ���ѺƷ��Ϣ��");
					}else{
						if(AEConfirmValue == null){
							putMsg("ѺƷϵͳ��š�"+CLRSerialNo+"����û�����ѺƷ��ֵ");
						}else{
							//��ѺƷ��ֵ��ѺƷ������ֵת��Ϊdouble�����¶�����ٽ��бȽϣ�ֱ�ӷ���if�бȽ�������
							double AEConfirmValueD = DataConvert.toDouble(AEConfirmValue);
							double AIConfirmValueD = DataConvert.toDouble(AIConfirmValue);
							if(Math.abs(AEConfirmValueD-AIConfirmValueD) > 0.00000001){
								putMsg("ѺƷϵͳ��š�"+CLRSerialNo+"����¼��ѺƷ��ֵ��"+DataConvert.toMoney(AIConfirmValue)+"����ѺƷϵͳ������ֵ��"+DataConvert.toMoney(AEConfirmValue)+"����һ�£�");
							}
						}
					}
				}
				arrs.close();
			}
		}
    	/** ���ؽ������ **/
		if(messageSize() > 0){
			this.setPass(false);
		}else{
			this.setPass(true);
		}
		return null;
	}
}
