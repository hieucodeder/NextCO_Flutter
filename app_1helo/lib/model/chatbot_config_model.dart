class ChatbotModel {
  List<Data>? data;

  ChatbotModel({this.data});

  ChatbotModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> dataMap = <String, dynamic>{};
    if (this.data != null) {
      dataMap['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return dataMap;
  }
}

class Data {
  String? chatbotCode;
  String? userIndustry;
  String? queryRewrite;
  String? modelRerank;
  String? modelGenerate;
  String? fallbackResponse;
  String? systemPrompt;
  String? query;
  String? releventContext;
  int? topCount;
  double? threadHold;
  String? collectionName;
  int? temperature;
  String? lang;
  String? createdAt;
  String? updatedAt;
  dynamic slots;
  dynamic history;
  dynamic intentqueue;
  String? chatbotName;
  dynamic promptContent;
  dynamic slotsConfig;
  dynamic customizePrompt;
  String? promptId;

  Data({
    this.chatbotCode,
    this.userIndustry,
    this.queryRewrite,
    this.modelRerank,
    this.modelGenerate,
    this.fallbackResponse,
    this.systemPrompt,
    this.query,
    this.releventContext,
    this.topCount,
    this.threadHold,
    this.collectionName,
    this.temperature,
    this.lang,
    this.createdAt,
    this.updatedAt,
    this.slots,
    this.history,
    this.intentqueue,
    this.chatbotName,
    this.promptContent,
    this.slotsConfig,
    this.customizePrompt,
    this.promptId,
  });

  Data.fromJson(Map<String, dynamic> json) {
    chatbotCode = json['chatbot_code'];
    userIndustry = json['user_industry'];
    queryRewrite = json['query_rewrite'];
    modelRerank = json['model_rerank'];
    modelGenerate = json['model_generate'];
    fallbackResponse = json['fallback_response'];
    systemPrompt = json['system_prompt'];
    query = json['query'];
    releventContext = json['relevent_context'];
    topCount = json['top_count'];
    threadHold = json['thread_hold'];
    collectionName = json['collection_name'];
    temperature = json['temperature'];
    lang = json['lang'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    slots = json['slots'];
    history = json['history'];
    intentqueue = json['intentqueue'];
    chatbotName = json['chatbot_name'];
    promptContent = json['prompt_content'];
    slotsConfig = json['slots_config'];
    customizePrompt = json['customize_prompt'];
    promptId = json['prompt_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> dataMap = <String, dynamic>{};
    dataMap['chatbot_code'] = chatbotCode;
    dataMap['user_industry'] = userIndustry;
    dataMap['query_rewrite'] = queryRewrite;
    dataMap['model_rerank'] = modelRerank;
    dataMap['model_generate'] = modelGenerate;
    dataMap['fallback_response'] = fallbackResponse;
    dataMap['system_prompt'] = systemPrompt;
    dataMap['query'] = query;
    dataMap['relevent_context'] = releventContext;
    dataMap['top_count'] = topCount;
    dataMap['thread_hold'] = threadHold;
    dataMap['collection_name'] = collectionName;
    dataMap['temperature'] = temperature;
    dataMap['lang'] = lang;
    dataMap['created_at'] = createdAt;
    dataMap['updated_at'] = updatedAt;
    dataMap['slots'] = slots;
    dataMap['history'] = history;
    dataMap['intentqueue'] = intentqueue;
    dataMap['chatbot_name'] = chatbotName;
    dataMap['prompt_content'] = promptContent;
    dataMap['slots_config'] = slotsConfig;
    dataMap['customize_prompt'] = customizePrompt;
    dataMap['prompt_id'] = promptId;
    return dataMap;
  }
}
