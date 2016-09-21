package com.amarsoft.app.workflow.processdata;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.dict.als.cache.CodeCache;
/**
 * ��ȡ���ֿ��������ý��
 * @author xjzhao
 */
public class GetApproveResult implements IProcess {

	public String process(List<BusinessObject> bos,BusinessObjectManager bomanager, String paraName, String dataType,BusinessObject otherPara) throws Exception {
		if(bos == null || bos.isEmpty()) return "2";
		String approveResult = "RF";
		String riskLevel = "";
		int i = 0;
		
		PreparedStatement ps = null,ft = null;
		ResultSet rs = null,fts = null;
		String flowNo = otherPara.getString("FlowNo");
		String phaseNo = otherPara.getString("PhaseNo");
		String flowVersion = otherPara.getString("FlowVersion");
		String flowSerialNo = otherPara.getString("FlowSerialNo");
		
		/*
		try
		{
			//�жϵ�ǰ�׶��Ƿ�Ϊ��һ������(i=0Ϊ��һ������)
			ft = bomanager.getConnnection().prepareStatement("select count(*) from FLOW_TASK FT where FT.FlowSerialNo = ? and PhaseNo in(select FM.PhaseNo from FLOW_MODEL FM where FM.FlowNo = ? and FM.FlowVersion = ? and FM.PhaseType = '0050') and FT.PhaseNo <> ?");
			ft.setString(1, flowSerialNo);
			ft.setString(2, flowNo);
			ft.setString(3, flowVersion);
			ft.setString(4, phaseNo);
			fts = ft.executeQuery();
			if(fts.next()){
				i = fts.getInt(1);
			}
			fts.close();
			//ֻ�е�һ�����ڲŸ��ݾ��߾�����������
			if(i > 0) return "2";
			
			ps = bomanager.getConnnection().prepareStatement("select Approve_Result from INTF_RDS_OUT_MESSAGE where ObjectType = ? and ObjectNo = ? and CallType = '02' and ReturnCode='0' and FlowStatus in('1','2') ");
			for(BusinessObject bo:bos)
			{
				String objecttype=bo.getBizClassName();
				String objectno=bo.getString("ObjectNo");
				ps.setString(1, objecttype);
				ps.setString(2, objectno);
				rs = ps.executeQuery();
				if(rs.next())
				{
					String approveResultTemp = rs.getString(1);
					if(approveResultTemp != null && !"".equals(approveResultTemp))
					{
						com.amarsoft.dict.als.object.Item item = CodeCache.getItem("CallApproveResult", approveResultTemp);
						if(item ==  null) continue;
						String riskLevelTemp = item.getRelativeCode();
						if(riskLevelTemp.compareTo(riskLevel) > 0)
						{
							riskLevel = riskLevelTemp;
							approveResult = approveResultTemp;
						}
					}
				}
				rs.close();
				rs = null;
			}
		}catch(Exception ex)
		{
			throw ex;
		}
		finally
		{
			if(rs != null) rs.close();
			if(ft != null) ft.close();
			if(ps != null) ps.close();
			if(fts != null) fts.close();
		}
		*/
		if(approveResult != null && !"".equals(approveResult))
		{
			//���ϵͳ���߽���� ���Զ�ͨ�� �����������Ϊ���ܾ� ��ʱ ��ϵͳ���̰��� ���˹����� ����ת����һ���ڣ�
			if("AP".equals(approveResult) && !"1".equals(otherPara.getString("PhaseActionType"))) return "2";
			com.amarsoft.dict.als.object.Item item = CodeCache.getItem("CallApproveResult", approveResult);
			if(item != null)
			{
				return item.getItemAttribute();
			}
		}
		
		return "2";//Ĭ��
	}

}
