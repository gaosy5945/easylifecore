




var sHtmlMesssage={
		"1":"请选择一条信息！",
		"2":"您确定删除该信息吗？",
		"3":"对不起，您无权删除这条信息！",
		"4":"信息保存成功！",
		"5":"对不起，信息保存失败！",
		"6":"确定信息补充完成吗？",
		"7":"信息删除成功！",
		"8":"对不起，删除信息失败！",
		"9":"提交失败！",
		"10":"上传文件失败！",
		"11":"保存失败，请稍后重试！",
		"12":"确定信息已保存了吗？",
		"13":"上传文件成功！"	,
		"14":"您确实要退出吗？",
		"15":"对不起，您不具备该客户查看权！",
		"16":"对不起，你没有信息维护的权限！",
		"17":"确信需要提交该记录吗？",
		"18":"提交成功！",
		"19":"操作失败，请稍候重试！",
		"20":"两次输入信息不一致，请确认!",
		"21":"用户权限保存成功！",
		"22":"角色权限保存成功！",
		"23":"请先选择一个节点！",
		"24":"请至少选择一条信息！",
		"25":"只能在JSP下增加Button！",
		"26":"只能在Model下增加JSP文件！",
		"27":"只能在一个Model下增加Model！",
		"28":"已经提交的信息不能再次提交！",
		"29":"确认信息保存吗？",
		"30":"对不起，系统中没有满足该条件的信息，请重新输入查询条件！",
		"31":"请先选择一个人员!",
		"32":"请先选择一个角色!",
		"33":"只能在菜单下增加新菜单！",
		"34":"删除此信息将会同时影响此信息的相关权限，您确定删除该信息吗？",
		"35":"指标不全，不能进行担保评级和债项综合评级！",
		"36":"请输入客户组织机构代码或名称！",
		"37":"请输入客户组织机构代码和客户名称！",
		"38":"有数据项未录入信息，请检查！",
		"39":"权限设定保存成功！",
		"40":"提交后将不能进行修改操作，确定提交吗？",
       	"41":"保存失败，原因字数过多！",
       	"42":"您确定将该信息终结吗？",
		"43":"终结成功！",
		"44":"是否确定取消新增？",
		"45":"该删除操作将将其关联信息一起删除，是否继续？",
		"46":"删除该数据库连接，将同时删除与其关联的应用，是否继续？",
		"47":"删除该应用，将同时删除与其关联的组件信息，是否继续？",
		"48":"删除该组件，将同时删除与其关联的页面注册信息，是否继续？",
		"49":"删除该流程，将同时删除该审批流程的模型，是否继续？",
		"50":"删除该评估表，将同时删除该评估表对应的模型，是否继续？",
		"51":"删除该分类模板，将同时删除该分类模板对应的模型，是否继续？",
		"52":"删除该向导，将同时删除该向导对应的任务阶段及输入输出组件，是否继续？",
		"53":"删除该任务阶段，将同时删除该任务阶段对应的输入输出组件，是否继续？",
		"54":"删除该类，将同时删除该类关联的方法，是否继续？",
		"55":"该合同已被其它重组申请关联，请重新选择关联合同！",
		"56":"您确定将该信息归档吗？",
		"57":"归档成功！",
		"58":"您确定将该信息归档取消吗？",
		"59":"取消归档成功！",
		"60":"归档失败！",
		"61":"取消归档失败！",
		"62":"终结失败！",
		"63":"您确定将该信息终结取消吗？",
		"64":"取消终结成功！",
		"65":"取消终结失败！",
		"66":"请至少选择一项！",
		"67":"删除该格式化报告模板，将同时删除该模板对应的格式化报告定义，是否继续？",
		"68":"您确定将该格式化报告定义删除吗",
		"69":"您确定将该格式化报告参数删除吗",
		"70":"您确定取消该信息吗？"
};

function  getHtmlMessage(iNo){
	return sHtmlMesssage[iNo];
}

var sBusinessMesssage={
		"001":"请先保存审批授权信息，然后才能进行测试！",
		"002":"请在选择阶段之前先选择流程！",
		
		"101":"贷款卡号有误！\r\n请重新输入贷款卡号！",
		"102":"组织机构代码有误！",
		"103":"客户已成功引入，要立即申请该客户的管户权吗？",
		"104":"客户名称不能为空！\r\n请输入客户名称",
		"105":"该客户已被自己引入过，请确认！",
		"106":"客户规模转换成功！",
		"107":"客户规模转换失败！\r\n请重新操作",
		"108":"客户引入成功！",
		"109":"新增客户成功！",
		"110":"该信息所属客户已删除！  ",
		"111":"该客户所属合同业务未终结，不能删除！",
		"112":"该客户所属最终审批意见未终结，不能删除！",
		"113":"该客户所属申请业务未终结，不能删除！",
		"114":"您确定要将该客户加入重点客户链接吗？",
		"115":"对不起，你没有查看该客户的权限！",
		"116":"已提交申请,不能再次提交！",
		"117":"您已经拥有该客户的所有权限！",
		"118":"营业执照到期日必须晚于营业执照登记日！",
		"119":"所在国家(地区)不为中华人民共和国时，客户英文名不能为空！",
		"120":"注册地址邮政编码有误！\r\n请重新输入注册地址邮政编码",
		"121":"联系电话有误！\r\n请重新输入联系电话",
		"122":"所选国家不是中国，无需选择地区！",
		"123":"尚未选择国家，无法选择地区！",		
		"124":"传真电话有误！\r\n请重新输入传真电话",
		"125":"财务部联系电话！\r\n请重新输入财务部联系电话",
		"126":"上级公司名称不能为空！",
		"127":"上级公司贷款卡编号和上级公司组织机构代码必须录入一项！",
		"128":"上级公司组织机构代码有误！\r\n请重新输入上级公司组织机构代码",
		"129":"上级公司贷款卡编号有误！\r\n请重新输入上级公司贷款卡编号",
		"130":"公司E－Mail有误！\r\n请重新输入公司E－Mail",
		"131":"家族成员所在企业贷款卡编号有误！\r\n请重新输入家族成员所在企业贷款卡编号",
		"132":"营业执照登记日必须早于当前日期！",
		"133":"请先选择管户机构！",
		"134":"出生日期必须早于当前日期！",
		"135":"担任该职务时间必须早于当前日期！",
		"136":"担任该职务时间必须晚于出生日期！",
		"137":"投资日期必须早于当前日期！",
		"138":"所有股东的出资比例(%)之和不能超过100%！",
		"139":"投向企业贷款卡编号有误！\r\n请重新输入投向企业贷款卡编号",
		"140":"关系建立时间必须早于当前日期！",
		"141":"录入的客户不能为其本身！",
		"142":"上市日期必须早于当前日期！",
		"143":"发行时间必须早于当前日期！",
		"144":"统计截止日期必须早于当前日期！",
		"145":"认证日期必须早于当前日期！",
		"146":"有效日期必须晚于认证日期！",
		"147":"请选择客户类型！",
		"148":"请选择证件类型！",
		"149":"证件号码未输入！",
		"150":"判决执行日期必须早于当前日期！",
		"151":"发生日期必须早于当前日期！",
		"152":"证件号码输入不一致！",
		"153":"计划竣工日期必须晚于开工日期！",
		"154":"竣工日期必须晚于开工日期！",
		"155":"调查日期必须早于当前日期！",
		"156":"身份证号码有误！",
		"157":"此项目在业务信息中已经录入，不能删除！",
		"158":"所选项目已被该业务引入,不能再次引入！",
		"159":"引入关联项目成功！",
		"160":"引入关联项目失败！\r\n请重新引入",
		"161":"编制日期必须早于当前日期！",
		"162":"客户概况信息输入不完整，请先输入客户概况信息！",
		"163":"报表截止日期必须早于当前日期！",
		"164":"统计截止日期必须晚于认证日期！",
		"165":"债券起始日期必须早于当前日期！",
		"166":"债券到期日期必须晚于债券起始日期！",
		"167":"债券起始日期必须早于统计截止日期！",
		"168":"纳税日期必须早于当前日期！",
		"169":"区间结束日期必须晚于区间开始日期！",
		"170":"起始日必须早于当前日期！",
		"171":"起始日必须早于统计截止日期！",
		"172":"到期日必须晚于起始日！",
		"173":"请选择要分析的报表！",
		"174":"至少要选一个指标进行图形展现！",
		"175":"一次点选不超过6个项目,请去掉一些项目再进行图形展现！",
		"176":"请至少选择两期报表用作趋势分析！",
		"177":"请选择至少三期报表！",
		"178":"请选择基期截至日期！",
		"179":"请选择二期截至日期！",
		"180":"请选择三期截至日期！",
		"181":"请选择近期截至日期！",
		"182":"请选择基准年份！",
		"183":"请选择预测年数！",
		"184":"预测记录已存在，请重新增加记录！",
		"185":"至少需要近5年中的一年的财务报表才能进行现金流量的预测！",
		"186":"请输入现金流预测参数的假定值，并进行现金流预测！",
		"187":"现金流预测记录删除完毕！",
		"188":"分析日期必须早于当前日期！",
		"189":"本期信用等级评估记录已存在，请选择其他月份！",
		"190":"对不起，你没有信用等级评估的权限！",
		"191":"请先选择会计报表月份！",
		"192":"请输入正确的会计报表月份格式（YYYY/MM）！",
		"193":"请先选择一个模型！",
		"194":"没有指定默认的模型！",
		"195":"该期信用等级评估记录已存在！",		
		"196":"该笔信用等级评估记录已认定完成，不能再进行认定！",
		"197":"请选择紧急行动！",
		"198":"请输入必要的项！",
		"199":"请选择必要的项！",
		"200":"出生日期和身份证中的出生日期不一致！",
		"201":"出生日期必须晚于1900/01/01！",
		"202":"居住地址邮编有误！\r\n请重新输入居住地址邮编",
		"203":"住宅电话有误！\r\n请重新输入住宅电话",
		"204":"手机号码有误！\r\n请重新输入手机号码",
		"205":"电子邮箱有误！\r\n请重新输入电子邮箱",
		"206":"通讯地址邮编有误！\r\n请重新输入通讯地址邮编",
		"207":"单位地址邮编有误！\r\n请重新输入单位地址邮编",
		"208":"单位电话有误！\r\n请重新输入单位电话",
		"209":"本单位工作起始日必须早于当前日期！",
		"210":"本单位工作起始日必须晚于出生日期！",
		"211":"文件大于2048k，不能上传！",
		"212":"请选择一个文件名！",
		"213":"投保日期必须早于当前日期！",
		"214":"到期日期必须晚于投保日期！",
		"215":"退保日期必须晚于投保日期！",
		"216":"退保日期必须早于当前日期！",
		"217":"统计截止日期必须晚于投保日期！",
		"218":"买入日期必须早于当前日期！",
		"219":"卖出日期必须晚于买入日期！",
		"220":"统计截止日期必须晚于买入日期！",
		"221":"卖出日期必须早于当前日期！",
		"222":"统计截止日期必须晚于认证日期！",
		"223":"主办客户经理联系电话有误！\r\n请重新输入主办客户经理联系电话",
		"224":"客户权限保存成功！",
		"225":"请先选择客户类型！",
		"226":"请先选择客户！",
		"227":"该贷款卡编号已被其他客户占用！\r\n请重新输入贷款卡编号",
		"228":"该上级公司贷款卡编号已被其他客户占用！\r\n请重新输入上级公司贷款卡编号",
		"229":"该家族成员所在企业贷款卡编号已被其他客户占用！\r\n请重新输入家族成员所在企业贷款卡编号",
		"230":"股东贷款卡编号有误！\r\n请重新输入股东贷款卡编号",
		"231":"该股东贷款卡编号已被其他客户占用！\r\n请重新输入股东贷款卡编号",
		"232":"该投向企业贷款卡编号已被其他客户占用！\r\n请重新输入投向企业贷款卡编号",
		"233":"关联方贷款卡编号有误！\r\n请重新输入关联方贷款卡编号",
		"234":"该关联方贷款卡编号已被其他客户占用！\r\n请重新输入关联方贷款卡编号",
		"235":"权利人贷款卡编号有误！\r\n请重新输入权利人贷款卡编号",
		"236":"该权利人贷款卡编号已被其他客户占用！\r\n请重新输入权利人贷款卡编号",
		"237":"新权利人贷款卡编号有误！\r\n请重新输入新权利人贷款卡编号",
		"238":"该新权利人贷款卡编号已被其他客户占用！\r\n请重新输入新权利人贷款卡编号",
		"239":"出质人贷款卡编号有误！\r\n请重新输入出质人贷款卡编号",
		"240":"该出质人贷款卡编号已被其他客户占用！\r\n请重新输入出质人贷款卡编号",
		"241":"新出质人贷款卡编号有误！\r\n请重新输入新出质人贷款卡编号",		
		"242":"该笔信息已加入重点信息链接！",
		"243":"加入重点信息链接成功！",
		"244":"该新出质人贷款卡编号已被其他客户占用！\r\n请重新输入新出质人贷款卡编号",
		"245":"新权利人名称和原权利人名称不能相同！",
		"246":"新出质人名称和原出质人名称不能相同！",
		"247":"请选择行业种类细项！",
		"248":"您选择的行业需要细分到小类！",
		"249":"您无权更改客户类型！",
		"250":"证件号码长度有误！",
		"251":"并非集团客户，不需要填写上级信息！",
		"252":"从业年龄应当小于100年，请检查！",
		"253":"余额应当小于等于金额！",
		"254":"期限必须大于0！",
		"255":"机构电话有误！请重新输入",
		"256":"申请金额必须大于0！",
		"257":"该股东已经存在，请不要修改用户名！",
		"258":"结束日必须晚于开始日！",
		
		"400":"确实要冻结该笔授信额度吗？",
		"401":"冻结授信额度失败！",
		"402":"冻结授信额度成功！",
		"403":"确实要解冻该笔授信额度吗？",
		"404":"解冻授信额度失败！",
		"405":"解冻授信额度成功！",
		"406":"确实要终止该笔授信额度吗？",
		"407":"终止授信额度失败！",
		"408":"终止授信额度成功！",
		"409":"生效日必须晚于或等于当前日期！",
		"410":"起始日必须晚于或等于当前日期！",
		"411":"到期日必须晚于生效日！",
		"412":"业务关联关系成功转移！",
		"413":"系统中不存在担保人的客户基本信息，不能查看！",
		"414":"担保人的贷款卡编号有误！\r\n请重新输入担保人的贷款卡编号",
		"415":"该担保合同已经引入！",
		"416":"引入担保合同成功！",
		"417":"您真的想失效担保合同吗？",
		"418":"您真的想将担保合同由失效变为生效吗？",
		"419":"该担保人的贷款卡编号已被其他客户占用！\r\n请重新输入担保人的贷款卡编号",
		"420":"要把这个合同信息加入重点合同链接中吗？",
		"421":"您真的想将该笔合同置为完成放贷吗？",
		"422":"该笔合同已经置为完成放贷！",
		"423":"您真的想对该笔合同进行再次放贷操作吗？",
		"424":"该笔合同已经置为可再次放贷！",
		"425":"该合同为补登合同，不能删除！",
		"426":"该合同已经被终结了，不能删除！",
		"427":"该合同已经完成放贷了，不能删除！",
		"428":"该合同已经出帐了，不能删除！",
		"429":"该合同管户人为其它人员，不能删除！",
		"430":"该授信额度已被占用，不能删除！",
		
		"486":"该申请已经提交了，不能再次提交！",
		"487":"确实要变更借据的关联合同吗？",
		"488":"受益人邮编有误！\r\n请重新输入受益人邮编！",
		"489":"开证行邮编有误！\r\n请重新输入开证行邮编！",
		"490":"如果提款方式为分次提款时，需输入提款说明！",
		"491":"如果还款方式为分次还款时，需输入还款说明！",
		"492":"选择远期信用证类型时，需输入远期信用证付款期限(月)！",
		"493":"选择远期信用证类型时，需输入远期信用证是否已承兑！",
		"494":"选择远期信用证类型时，需输入远期信用证付款期限！",
		"495":"该业务已经移交给保全部，不能再次移交！",		
		"496":"您确认要将该出帐申请退回上一环节吗？",
		"497":"您确认要将该最终审批意见退回上一环节吗？",
		"498":"确认收回该笔业务吗？",
		"499":"该最终审批意见所对应的流程任务不存在，请核对！",
		"500":"该申请所对应的流程任务不存在，请核对！",
		"501":"该业务未签署意见,不能提交,请先签署意见！",
		"502":"该保证人不能为自己申请的业务进行保证！",
		"503":"尽职调查报告有可能更改，是否重新生成尽职调查报告后再查看！",
		"504":"是否要增加打印内容,如果是请点击确定按钮！",
		"505":"尽职调查报告还未填写，请先填写尽职调查报告再查看！",		
		"506":"请选择发生类型！",
		"507":"请选择发生日期！",
		"508":"发生日期必须早于或等于当前日期！",
		"509":"您确认要将该申请退回上一环节吗？",
		"510":"该业务已签署了意见，不能再退回前一步！",
		"511":"展期金额必须等于展期前的业务余额！",
		"512":"批准展期金额(元)必须等于申请中的展期金额(元)！",
		"513":"批准票据总金额(元)必须小于或等于申请中的票据总金额(元)！",
		"514":"批准信用证金额(元)必须小于或等于申请中的信用证金额(元)！",
		"515":"批准单据金额(元)必须小于或等于申请中的单据金额(元)！",
		"516":"批准租赁黄金金额必须小于或等于申请中的租赁黄金金额！",
		"517":"批准敞口总额度(元)必须小于或等于申请中的申请敞口总额度(元)！",		
		"518":"批准金额(元)必须小于或等于申请中的金额(元)！",			
		"550":"批准的期限必须小于或等于申请的期限！",
		"551":"有其他担保方式时，主要担保方式不能用信用担保！",
		"552":"展期金额(元)必须等于最终审批意见中的批准展期金额(元)！",		
		"553":"票据总金额(元)必须小于或等于最终审批意见中的批准票据总金额(元)！",
		"554":"信用证金额(元)必须小于或等于最终审批意见中的批准信用证金额(元)！",
		"555":"单据金额(元)必须小于或等于最终审批意见中的批准单据金额(元)！",
		"556":"租赁黄金金额必须小于或等于最终审批意见中的批准租赁黄金金额！",
		"557":"敞口总额度(元)必须小于或等于最终审批意见中的批准敞口总额度(元)！",		
		"558":"合同金额(元)必须小于或等于最终审批意见中的批准金额(元)！",		
		"559":"基准年利率(%)必须大于或等于最终审批意见中的基准年利率(%)！",
		"560":"利率浮动值必须大于或等于最终审批意见中的利率浮动值！",
		"561":"买方应付贴现利息(元)必须小于或等于贴现利息(元)！",
		"562":"保证金金额(元)必须小于或等于申请金额(元)！",
		"563":"手续费金额(元)必须小于或等于申请金额(元)！",
		"564":"保证金金额(元)必须小于或等于信用证金额(元)！",
		"565":"手续费金额(元)必须小于或等于信用证金额(元)！",
		"566":"保证金金额(元)必须小于或等于单据金额(元)！",
		"567":"手续费金额(元)必须小于或等于单据金额(元)！",
		"568":"保证金金额(元)必须小于或等于申请敞口总额度(元)！",
		"569":"保证金金额(元)必须小于或等于敞口总额度(元)！",
		"570":"保证金金额(元)必须小于或等于批准金额(元)！",
		"571":"手续费金额(元)必须小于或等于批准金额(元)！",
		"572":"出帐中录入的金额必须小于或等于合同的可用金额！",
		"573":"此业务合同已没有可用金额，不能进行放贷申请！",
		"574":"保证金金额(元)必须小于或等于合同金额(元)！",
		"575":"手续费金额(元)必须小于或等于合同金额(元)！",
		"576":"检查频率必须小于或等于批准的期限！",
		"577":"有其他反担保方式时，主要反担保方式不能用信用担保！",
				
		"578":"展期到期日必须晚于展期起始日！",				
		"579":"到期日必须晚于开证日！",
		"580":"信用证有效期必须晚于开证日！",
		"581":"到期日必须晚于发放日！",
		"582":"到期付款日必须晚于签发日！",
		"583":"到期日必须晚于出票日！",
		"584":"失效日期必须晚于生效日期！",
		"585":"到期日必须晚于起始日！",
		"586":"到期日必须晚于项下业务起始日！",
		"587":"合同到期日必须晚于合同起始日！",
		"588":"到期日必须晚于起贷日！",
		"589":"到期日必须晚于起息日！",
		"590":"信用证有效期必须晚于业务日期！",
		"591":"合同期限必须小于或等于最终审批意见中的期限（仅控制整月）！",		
		"592":"出帐的展期起始日必须晚于或等于合同的展期起始日！",
		"593":"出帐的起贷日必须晚于或等于合同的起始日！",
		"594":"出帐的生效日期必须晚于或等于合同的开证日！",
		"595":"出帐的生效日期必须晚于或等于合同的发放日！",
		"596":"出帐的生效日期必须晚于或等于合同的签发日！",
		"597":"出帐的生效日期必须晚于或等于合同的生效日期！",
		"598":"出帐的生效日期必须晚于或等于合同的起始日！",
		"599":"出帐的起息日必须晚于或等于合同的起始日！",
		"600":"出帐的业务日期必须晚于或等于合同的开证日！",
		"601":"出帐的签发日必须晚于或等于合同的出票日！",
		"602":"出帐的展期到期日必须早于或等于合同的展期到期日！",
		"603":"出帐的到期日必须早于或等于合同的到期日！",
		"604":"出帐的失效日期必须早于或等于合同的到期日！",
		"605":"出帐的失效日期必须早于或等于合同的到期付款日！",
		"606":"出帐的失效日期必须早于或等于合同的失效日期！",
		"607":"出帐的信用证有效期必须早于或等于合同的信用证有效期！",
		"608":"出帐的到期付款日必须早于或等于合同的到期日！",
		"609":"当计息周期选择按固定月数计息时,固定周期必须输入,输入范围为2-12！",
		"610":"当贴现付息方式选择协议付息时输入买方付息比例！",
		"611":"当扣款周期选择按固定月数计息时,固定月数必须输入,输入范围为2-12！",
		"612":"额度生效日必须晚于或等于起始日！",
		"613":"额度生效日必须早于到期日！",
		"614":"额度使用最迟日期必须晚于额度生效日！",
		"615":"额度使用最迟日期必须早于到期日！",
		"616":"额度项下业务最迟到期日期必须晚于额度生效日！",
		"617":"额度项下业务最迟到期日期必须晚于额度使用最迟日期！",
		
		"649":"该合同【余额＋表内欠息金额＋表外欠息金额>0】不能进行终结操作！",	
		"650":"你真的想完成该报告吗？",
		"651":"该贷后检查报告无法完成，请先完成风险分类！",
		"652":"该贷款用途报告无法完成，请先输入提款记录和用款纪录！",
		"653":"该报告已完成！",
		"654":"你确定要撤回该报告吗？",
		"655":"报告撤回完成！",
		"656":"预警信号分发成功！",
		"657":"预警信号分发失败！",
		"658":"风险分类没有完成！",
		"659":"您确定已经分类完成吗？",
		"660":"完成资产风险分类失败！",
		"661":"完成资产风险分类成功！",
		"662":"当前认定金额之和与合同当前余额不相等，请调整认定金额！",
		"663":"请选择直接认定为损失类的具体原因或输入其他原因！",
		"664":"请选择直接认定为可疑类的具体原因或输入其他原因！",		
		"665":"该期资产风险分类已经存在！",
		"666":"该期资产风险分类信息删除完成！",
		"667":"将要删除该该期资产风险分类信息，继续吗？",
		"668":"该期资产风险分类数据保存完成！",
		"669":"该期资产风险分类测算完成！",
		"670":"该期资产风险分类测算没有正常完成！",		
		"671":"请选择风险分类月份！",
		"672":"请选择需资产风险分类的合同流水号！",
		"673":"请选择需资产风险分类的借据流水号！",
		"674":"该期资产风险分类新增失败！",
		"675":"该期资产风险分类新增成功！",
		"676":"还款方式补登成功！",
		"677":"还款方式补登失败！",
		"678":"尚未生成预警检查报告！",
		"679":"审批期限和审批金额必须大于0！",		
		
		"750":"现管理人员不能与原管理人员相同！",
		"751":"该案件的关联合同删除成功！",
		"752":"该案件的关联合同删除失败，请重新操作！",
		"753":"所选合同已被该案件引入,不能再次引入！",
		"754":"引入关联合同成功！",
		"755":"引入关联合同失败，请重新操作！",
		"756":"所选合同已被该重组方案引入,不能再次引入！",
		"757":"由于该重组方案已经与申请业务建立了关联关系，故它的关联合同信息不能删除！",
		"758":"该重组方案的关联合同删除成功！",
		"759":"该重组方案的关联合同删除失败，请重新操作！",
		"760":"引入关联合同失败，请重新操作！",
		"761":"您未改变移交类型，操作取消！",
		"762":"是否真的更改移交类型？",
		"763":"移交类型变更成功！",	
		"764":"请选择不良资产管理人！",
		"765":"请选择认定人！",
		"766":"您确认该抵债资产转表内吗？",
		"767":"该抵债资产转表内成功！",
		"768":"该抵债资产转表内失败，请重新操作！",
		"769":"您确认该抵债资产转表外吗？",
		"770":"该抵债资产转表外成功！",
		"771":"该抵债资产转表外失败，请重新操作！",
		"772":"转入下阶段成功！",
		"773":"转入下阶段失败！",
		"774":"该查封资产真的要退出查封吗？",
		"775":"该查封资产已成功退出查封！",
		"776":"该查封资产退出查封失败！",
		"777":"您真的想将该案件转到下阶段吗？",
		"778":"请选择转入阶段！",
		"779":"转入阶段与当前阶段相同！",
		"780":"请选择案件类型！",
		"781":"请选择终结类型！",
		"782":"请选择终结日期！",
		"783":"请选择抵债资产类型！",
		"784":"该不良资产已成功退回给原管户人！",
		"785":"您真的想将此不良资产退回给原管户人吗？",
		
		"850":"该抵押物已关联担保合同，不能删除！",
		"851":"确认将该抵押物入库吗？",
		"852":"抵押物入库成功！",
		"853":"抵押物入库失败，请重新操作！",
		"854":"抵押物出库成功！",
		"855":"抵押物出库失败，请重新操作！",
		"856":"确认将该抵押物再回库吗？",
		"857":"该质物已签担保合同，不能删除！",
		"858":"确认将该质物入库吗？",
		"859":"质物入库成功！",
		"860":"质物入库失败，请重新操作！",
		"861":"质物出库成功！",
		"862":"质物出库失败，请重新操作！",
		"863":"确认将该质物再回库吗？",
		"864":"引入质物成功！",
		"865":"引入质物失败！\r\n请重新引入",
		"866":"质物已经引入过，请选择其他质物！",
		"867":"引入抵押物成功！",
		"868":"引入抵押物失败！\r\n请重新引入",
		"869":"抵押物已经引入过，请选择其他抵押物！",
	
		"900":"请输入机构编号！",
		"901":"请选择级别！",
		"902":"删除该角色的同时将删除该角色对应的权限，确定删除该角色吗？",
		"903":"系统错误，请通知管理员！",
		"904":"数据同步成功！",
		"905":"同步失败，请检查原因，再试试！",
		"906":"您确定给所选的所有用户新增所选的所有角色吗？",
		"907":"请选择要新增的用户角色！",
		"908":"请选择要新增角色的用户！",
		"909":"您确定要删除所选用户中您所选的所有角色吗？",
		"910":"请选择要删除的用户角色！",
		"911":"请选择要删除角色的用户！",
		"912":"您确定将所选人员引入到本机构中吗？",
		"913":"人员引入成功！",
		"914":"人员转移成功！",
		"915":"人员转移失败！",
		"916":"您确定要初始化该用户的密码吗？",
		"917":"用户密码初始化成功！",		
		"918":"请选择待处理业务！",
		"919":"只能逐笔查看业务详情！",
		"920":"确认转移该待处理业务吗？",
		"921":"请选择转授权后的用户！",
		"922":"不允许待处理业务转授权在同一用户间进行，请重新选择转授权后的用户！",
		"923":"请输入需变更的客户信息！",
		"924":"变更客户信息成功!",
		"925":"变更客户信息失败!",
		"926":"确认转移该合同的入账机构吗？",
		"927":"请选择转移后的入账机构！",
		"928":"不允许业务入账机构转移在同一机构中进行，请重新选择转移后的入账机构！",
		"929":"入账机构转移成功！",
		"930":"入账机构转移失败！",
		"931":"确认合并该客户的业务吗？",
		"932":"请选择合并后的客户！",
		"933":"不允许在同一客户间进行业务合并操作，请重新选择合并后的客户！",
		"934":"业务合并成功！",
		"935":"业务合并失败！\r\n请点击业务合并列表上的合并按钮重新进行业务合并",
		"936":"确认转移该合同吗？",
		"937":"请选择转移后的客户经理！",
		"938":"不允许合同转移在同一客户经理间进行，请重新选择转移后的客户经理！",
		"939":"合同转移成功！",
		"940":"合同转移失败！",
		"941":"接受客户经理对该合同的客户没有业务办理权，不能转移！",
		"942":"确认交接该客户吗？",
		"943":"请选择交接后的客户经理！",
		"944":"不允许在同一客户经理间进行客户交接操作，请重新选择交接后的客户经理！",
		"945":"客户交接成功！",
		"946":"客户交接失败！",
		"947":"无效客户被成功清理！",
		"948":"请选择用户！",
		"949":"确认转移该用户角色吗？",
		"950":"请选择转移后的用户！",
		"951":"不允许用户角色转换在同一用户间进行，请重新选择转换后用户！",
		"952":"确认转移该人员吗？",
		"953":"请选择转移后的机构！",
		"954":"不允许人员转移在同一机构中进行，请重新选择转移后机构！",
		"955":"人员转移成功！",
		"956":"人员转移失败！",
		"957":"请先处理完在途业务申请再进行客户交接！",
		"958":"所在国家(地区)为中华人民共和国时,省份、直辖市、自治区不能为空！",
		"959":"输入的值有误，请规范输入！"
};

function  getBusinessMessage(iNo){
	return sBusinessMesssage[iNo];
}

var sGuarantyTypeMessage={
		"0402020401":"境外AA-级及以上国家、地区政府注册的商业银行和证券公司发行的BBB级及以上的金融债券",
		"0402020402":"境外AA-级及以上国家、地区政府注册的商业银行和证券公司发行的BBB级以下的金融债券及无评级",
		"0402020601":"其他BBB级及以上的金融债券",
		"0402020602":"其他BBB级以下的金融债券及无评级",
		"0402030301":"境外AA-级及以上国家和地区注册的商业银行和证券公司担保的BBB级及以上的公司债券",
		"0402030302":"境外AA-级及以上国家和地区注册的商业银行和证券公司担保的BBB级以下的公司债券及无评级",
		"0402030401":"我国中央政府投资的公用企业发行或由其担保的BBB级及以上的公司债券",
		"0402030402":"我国中央政府投资的公用企业发行或由其担保的BBB级以下的公司债券及无评级",
		"0402030501":"境外AA-级及以上国家或地区政府投资的公用企业发行或由其担保的BBB级及以上的公司债券",
		"0402030502":"境外AA-级及以上国家或地区政府投资的公用企业发行或由其担保的BBB级以下的公司债券及无评级",
		"0402030601":"其他BBB级及以上的公司债券",
		"0402030602":"其他BBB级以下的公司债券及无评级",
		"04030101":"属于沪深成分指数样本股的上市公司流通股股票",
		"04030102":"上市公司非样本流通股股票"
};

function  getGuarantyTypeMessage(iNo){
	return sGuarantyTypeMessage[iNo];
}