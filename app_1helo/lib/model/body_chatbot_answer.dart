class BodyChatbotAnswer {
  final String chatbotCode;
  final String chatbotName;
  final String collectionName;
  final String customizePrompt;
  final String fallbackResponse;
  final String genModel;
  final List<dynamic> history;
  final List<dynamic> intentQueue;
  final String language;
  final String platform;
  final String query;
  final String rerankModel;
  final String rewriteModel;
  final List<dynamic> slots;
  final List<dynamic> slotsConfig;
  final String systemPrompt;
  final double temperature;
  final double threadHold;
  final int topCount;
  final String type;
  final String userId;
  final String userIndustry;

  BodyChatbotAnswer({
    required this.chatbotCode,
    required this.chatbotName,
    required this.collectionName,
    required this.customizePrompt,
    required this.fallbackResponse,
    required this.genModel,
    required this.history,
    required this.intentQueue,
    required this.language,
    required this.platform,
    required this.query,
    required this.rerankModel,
    required this.rewriteModel,
    required this.slots,
    required this.slotsConfig,
    required this.systemPrompt,
    required this.temperature,
    required this.threadHold,
    required this.topCount,
    required this.type,
    required this.userId,
    required this.userIndustry,
  });

  // Factory constructor to create an instance from a JSON object
  factory BodyChatbotAnswer.fromJson(Map<String, dynamic> json) {
    return BodyChatbotAnswer(
      chatbotCode: json['chatbot_code'] ?? '',
      chatbotName: json['chatbot_name'] ?? '',
      collectionName: json['collection_name'] ?? '',
      customizePrompt: json['customize_prompt'] ?? '',
      fallbackResponse: json['fallback_response'] ?? '',
      genModel: json['genmodel'] ?? '',
      history: json['history'] ?? [],
      intentQueue: json['intentqueue'] ?? [],
      language: json['language'] ?? '',
      platform: json['platform'] ?? '',
      query: json['query'] ?? '',
      rerankModel: json['rerankmodel'] ?? '',
      rewriteModel: json['rewritemodel'] ?? '',
      slots: json['slots'] ?? [],
      slotsConfig: json['slots_config'] ?? [],
      systemPrompt: json['system_prompt'] ?? '',
      temperature: (json['temperature'] ?? 0).toDouble(),
      threadHold: (json['thread_hold'] ?? 0).toDouble(),
      topCount: json['top_count'] ?? 0,
      type: json['type'] ?? '',
      userId: json['user_id'] ?? '',
      userIndustry: json['user_industry'] ?? '',
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'chatbot_code': chatbotCode,
      'chatbot_name': chatbotName,
      'collection_name': collectionName,
      'customize_prompt': customizePrompt,
      'fallback_response': fallbackResponse,
      'genmodel': genModel,
      'history': history,
      'intentqueue': intentQueue,
      'language': language,
      'platform': platform,
      'query': query,
      'rerankmodel': rerankModel,
      'rewritemodel': rewriteModel,
      'slots': slots,
      'slots_config': slotsConfig,
      'system_prompt': systemPrompt,
      'temperature': temperature,
      'thread_hold': threadHold,
      'top_count': topCount,
      'type': type,
      'user_id': userId,
      'user_industry': userIndustry,
    };
  }
}
