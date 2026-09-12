// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $SubscriptionsTable extends Subscriptions
    with TableInfo<$SubscriptionsTable, SubscriptionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SubscriptionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _authorMeta = const VerificationMeta('author');
  @override
  late final GeneratedColumn<String> author = GeneratedColumn<String>(
    'author',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _feedUrlMeta = const VerificationMeta(
    'feedUrl',
  );
  @override
  late final GeneratedColumn<String> feedUrl = GeneratedColumn<String>(
    'feed_url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _artworkUrlMeta = const VerificationMeta(
    'artworkUrl',
  );
  @override
  late final GeneratedColumn<String> artworkUrl = GeneratedColumn<String>(
    'artwork_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _genreMeta = const VerificationMeta('genre');
  @override
  late final GeneratedColumn<String> genre = GeneratedColumn<String>(
    'genre',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _episodeCountMeta = const VerificationMeta(
    'episodeCount',
  );
  @override
  late final GeneratedColumn<int> episodeCount = GeneratedColumn<int>(
    'episode_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _subscribedAtMeta = const VerificationMeta(
    'subscribedAt',
  );
  @override
  late final GeneratedColumn<DateTime> subscribedAt = GeneratedColumn<DateTime>(
    'subscribed_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _lastRefreshedAtMeta = const VerificationMeta(
    'lastRefreshedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastRefreshedAt =
      GeneratedColumn<DateTime>(
        'last_refreshed_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _autoDownloadMeta = const VerificationMeta(
    'autoDownload',
  );
  @override
  late final GeneratedColumn<String> autoDownload = GeneratedColumn<String>(
    'auto_download',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('never'),
  );
  static const VerificationMeta _autoDownloadLimitMeta = const VerificationMeta(
    'autoDownloadLimit',
  );
  @override
  late final GeneratedColumn<int> autoDownloadLimit = GeneratedColumn<int>(
    'auto_download_limit',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(3),
  );
  static const VerificationMeta _autoDeletePlayedDaysMeta =
      const VerificationMeta('autoDeletePlayedDays');
  @override
  late final GeneratedColumn<int> autoDeletePlayedDays = GeneratedColumn<int>(
    'auto_delete_played_days',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _playbackSpeedOverrideMeta =
      const VerificationMeta('playbackSpeedOverride');
  @override
  late final GeneratedColumn<double> playbackSpeedOverride =
      GeneratedColumn<double>(
        'playback_speed_override',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    author,
    feedUrl,
    artworkUrl,
    genre,
    episodeCount,
    subscribedAt,
    lastRefreshedAt,
    autoDownload,
    autoDownloadLimit,
    autoDeletePlayedDays,
    playbackSpeedOverride,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'subscriptions';
  @override
  VerificationContext validateIntegrity(
    Insertable<SubscriptionRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('author')) {
      context.handle(
        _authorMeta,
        author.isAcceptableOrUnknown(data['author']!, _authorMeta),
      );
    } else if (isInserting) {
      context.missing(_authorMeta);
    }
    if (data.containsKey('feed_url')) {
      context.handle(
        _feedUrlMeta,
        feedUrl.isAcceptableOrUnknown(data['feed_url']!, _feedUrlMeta),
      );
    } else if (isInserting) {
      context.missing(_feedUrlMeta);
    }
    if (data.containsKey('artwork_url')) {
      context.handle(
        _artworkUrlMeta,
        artworkUrl.isAcceptableOrUnknown(data['artwork_url']!, _artworkUrlMeta),
      );
    }
    if (data.containsKey('genre')) {
      context.handle(
        _genreMeta,
        genre.isAcceptableOrUnknown(data['genre']!, _genreMeta),
      );
    }
    if (data.containsKey('episode_count')) {
      context.handle(
        _episodeCountMeta,
        episodeCount.isAcceptableOrUnknown(
          data['episode_count']!,
          _episodeCountMeta,
        ),
      );
    }
    if (data.containsKey('subscribed_at')) {
      context.handle(
        _subscribedAtMeta,
        subscribedAt.isAcceptableOrUnknown(
          data['subscribed_at']!,
          _subscribedAtMeta,
        ),
      );
    }
    if (data.containsKey('last_refreshed_at')) {
      context.handle(
        _lastRefreshedAtMeta,
        lastRefreshedAt.isAcceptableOrUnknown(
          data['last_refreshed_at']!,
          _lastRefreshedAtMeta,
        ),
      );
    }
    if (data.containsKey('auto_download')) {
      context.handle(
        _autoDownloadMeta,
        autoDownload.isAcceptableOrUnknown(
          data['auto_download']!,
          _autoDownloadMeta,
        ),
      );
    }
    if (data.containsKey('auto_download_limit')) {
      context.handle(
        _autoDownloadLimitMeta,
        autoDownloadLimit.isAcceptableOrUnknown(
          data['auto_download_limit']!,
          _autoDownloadLimitMeta,
        ),
      );
    }
    if (data.containsKey('auto_delete_played_days')) {
      context.handle(
        _autoDeletePlayedDaysMeta,
        autoDeletePlayedDays.isAcceptableOrUnknown(
          data['auto_delete_played_days']!,
          _autoDeletePlayedDaysMeta,
        ),
      );
    }
    if (data.containsKey('playback_speed_override')) {
      context.handle(
        _playbackSpeedOverrideMeta,
        playbackSpeedOverride.isAcceptableOrUnknown(
          data['playback_speed_override']!,
          _playbackSpeedOverrideMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SubscriptionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SubscriptionRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      author: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}author'],
      )!,
      feedUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}feed_url'],
      )!,
      artworkUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}artwork_url'],
      ),
      genre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}genre'],
      ),
      episodeCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}episode_count'],
      )!,
      subscribedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}subscribed_at'],
      )!,
      lastRefreshedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_refreshed_at'],
      ),
      autoDownload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}auto_download'],
      )!,
      autoDownloadLimit: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}auto_download_limit'],
      )!,
      autoDeletePlayedDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}auto_delete_played_days'],
      )!,
      playbackSpeedOverride: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}playback_speed_override'],
      ),
    );
  }

  @override
  $SubscriptionsTable createAlias(String alias) {
    return $SubscriptionsTable(attachedDatabase, alias);
  }
}

class SubscriptionRow extends DataClass implements Insertable<SubscriptionRow> {
  final int id;
  final String title;
  final String author;
  final String feedUrl;
  final String? artworkUrl;
  final String? genre;
  final int episodeCount;
  final DateTime subscribedAt;

  /// Última vez que o feed foi rebuscado e o cache atualizado (Fase 9).
  /// `null` = nunca desde a assinatura. Usado pra não rebuscar o mesmo feed
  /// toda hora ao abrir o app.
  final DateTime? lastRefreshedAt;

  /// Gestão automática por podcast (Fase 13). Defaults = comportamento
  /// atual (nada automático).
  ///
  /// `autoDownload`: `never` | `wifi` | `always`.
  final String autoDownload;

  /// Quantos episódios recentes manter baixados automaticamente.
  final int autoDownloadLimit;

  /// Apagar download já ouvido depois de N dias. `0` = nunca.
  final int autoDeletePlayedDays;

  /// Velocidade fixa pra este podcast (`null` = usa a global). Consumida
  /// pelo player na Fase 13/14.
  final double? playbackSpeedOverride;
  const SubscriptionRow({
    required this.id,
    required this.title,
    required this.author,
    required this.feedUrl,
    this.artworkUrl,
    this.genre,
    required this.episodeCount,
    required this.subscribedAt,
    this.lastRefreshedAt,
    required this.autoDownload,
    required this.autoDownloadLimit,
    required this.autoDeletePlayedDays,
    this.playbackSpeedOverride,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['author'] = Variable<String>(author);
    map['feed_url'] = Variable<String>(feedUrl);
    if (!nullToAbsent || artworkUrl != null) {
      map['artwork_url'] = Variable<String>(artworkUrl);
    }
    if (!nullToAbsent || genre != null) {
      map['genre'] = Variable<String>(genre);
    }
    map['episode_count'] = Variable<int>(episodeCount);
    map['subscribed_at'] = Variable<DateTime>(subscribedAt);
    if (!nullToAbsent || lastRefreshedAt != null) {
      map['last_refreshed_at'] = Variable<DateTime>(lastRefreshedAt);
    }
    map['auto_download'] = Variable<String>(autoDownload);
    map['auto_download_limit'] = Variable<int>(autoDownloadLimit);
    map['auto_delete_played_days'] = Variable<int>(autoDeletePlayedDays);
    if (!nullToAbsent || playbackSpeedOverride != null) {
      map['playback_speed_override'] = Variable<double>(playbackSpeedOverride);
    }
    return map;
  }

  SubscriptionsCompanion toCompanion(bool nullToAbsent) {
    return SubscriptionsCompanion(
      id: Value(id),
      title: Value(title),
      author: Value(author),
      feedUrl: Value(feedUrl),
      artworkUrl: artworkUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(artworkUrl),
      genre: genre == null && nullToAbsent
          ? const Value.absent()
          : Value(genre),
      episodeCount: Value(episodeCount),
      subscribedAt: Value(subscribedAt),
      lastRefreshedAt: lastRefreshedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastRefreshedAt),
      autoDownload: Value(autoDownload),
      autoDownloadLimit: Value(autoDownloadLimit),
      autoDeletePlayedDays: Value(autoDeletePlayedDays),
      playbackSpeedOverride: playbackSpeedOverride == null && nullToAbsent
          ? const Value.absent()
          : Value(playbackSpeedOverride),
    );
  }

  factory SubscriptionRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SubscriptionRow(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      author: serializer.fromJson<String>(json['author']),
      feedUrl: serializer.fromJson<String>(json['feedUrl']),
      artworkUrl: serializer.fromJson<String?>(json['artworkUrl']),
      genre: serializer.fromJson<String?>(json['genre']),
      episodeCount: serializer.fromJson<int>(json['episodeCount']),
      subscribedAt: serializer.fromJson<DateTime>(json['subscribedAt']),
      lastRefreshedAt: serializer.fromJson<DateTime?>(json['lastRefreshedAt']),
      autoDownload: serializer.fromJson<String>(json['autoDownload']),
      autoDownloadLimit: serializer.fromJson<int>(json['autoDownloadLimit']),
      autoDeletePlayedDays: serializer.fromJson<int>(
        json['autoDeletePlayedDays'],
      ),
      playbackSpeedOverride: serializer.fromJson<double?>(
        json['playbackSpeedOverride'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'author': serializer.toJson<String>(author),
      'feedUrl': serializer.toJson<String>(feedUrl),
      'artworkUrl': serializer.toJson<String?>(artworkUrl),
      'genre': serializer.toJson<String?>(genre),
      'episodeCount': serializer.toJson<int>(episodeCount),
      'subscribedAt': serializer.toJson<DateTime>(subscribedAt),
      'lastRefreshedAt': serializer.toJson<DateTime?>(lastRefreshedAt),
      'autoDownload': serializer.toJson<String>(autoDownload),
      'autoDownloadLimit': serializer.toJson<int>(autoDownloadLimit),
      'autoDeletePlayedDays': serializer.toJson<int>(autoDeletePlayedDays),
      'playbackSpeedOverride': serializer.toJson<double?>(
        playbackSpeedOverride,
      ),
    };
  }

  SubscriptionRow copyWith({
    int? id,
    String? title,
    String? author,
    String? feedUrl,
    Value<String?> artworkUrl = const Value.absent(),
    Value<String?> genre = const Value.absent(),
    int? episodeCount,
    DateTime? subscribedAt,
    Value<DateTime?> lastRefreshedAt = const Value.absent(),
    String? autoDownload,
    int? autoDownloadLimit,
    int? autoDeletePlayedDays,
    Value<double?> playbackSpeedOverride = const Value.absent(),
  }) => SubscriptionRow(
    id: id ?? this.id,
    title: title ?? this.title,
    author: author ?? this.author,
    feedUrl: feedUrl ?? this.feedUrl,
    artworkUrl: artworkUrl.present ? artworkUrl.value : this.artworkUrl,
    genre: genre.present ? genre.value : this.genre,
    episodeCount: episodeCount ?? this.episodeCount,
    subscribedAt: subscribedAt ?? this.subscribedAt,
    lastRefreshedAt: lastRefreshedAt.present
        ? lastRefreshedAt.value
        : this.lastRefreshedAt,
    autoDownload: autoDownload ?? this.autoDownload,
    autoDownloadLimit: autoDownloadLimit ?? this.autoDownloadLimit,
    autoDeletePlayedDays: autoDeletePlayedDays ?? this.autoDeletePlayedDays,
    playbackSpeedOverride: playbackSpeedOverride.present
        ? playbackSpeedOverride.value
        : this.playbackSpeedOverride,
  );
  SubscriptionRow copyWithCompanion(SubscriptionsCompanion data) {
    return SubscriptionRow(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      author: data.author.present ? data.author.value : this.author,
      feedUrl: data.feedUrl.present ? data.feedUrl.value : this.feedUrl,
      artworkUrl: data.artworkUrl.present
          ? data.artworkUrl.value
          : this.artworkUrl,
      genre: data.genre.present ? data.genre.value : this.genre,
      episodeCount: data.episodeCount.present
          ? data.episodeCount.value
          : this.episodeCount,
      subscribedAt: data.subscribedAt.present
          ? data.subscribedAt.value
          : this.subscribedAt,
      lastRefreshedAt: data.lastRefreshedAt.present
          ? data.lastRefreshedAt.value
          : this.lastRefreshedAt,
      autoDownload: data.autoDownload.present
          ? data.autoDownload.value
          : this.autoDownload,
      autoDownloadLimit: data.autoDownloadLimit.present
          ? data.autoDownloadLimit.value
          : this.autoDownloadLimit,
      autoDeletePlayedDays: data.autoDeletePlayedDays.present
          ? data.autoDeletePlayedDays.value
          : this.autoDeletePlayedDays,
      playbackSpeedOverride: data.playbackSpeedOverride.present
          ? data.playbackSpeedOverride.value
          : this.playbackSpeedOverride,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SubscriptionRow(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('author: $author, ')
          ..write('feedUrl: $feedUrl, ')
          ..write('artworkUrl: $artworkUrl, ')
          ..write('genre: $genre, ')
          ..write('episodeCount: $episodeCount, ')
          ..write('subscribedAt: $subscribedAt, ')
          ..write('lastRefreshedAt: $lastRefreshedAt, ')
          ..write('autoDownload: $autoDownload, ')
          ..write('autoDownloadLimit: $autoDownloadLimit, ')
          ..write('autoDeletePlayedDays: $autoDeletePlayedDays, ')
          ..write('playbackSpeedOverride: $playbackSpeedOverride')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    author,
    feedUrl,
    artworkUrl,
    genre,
    episodeCount,
    subscribedAt,
    lastRefreshedAt,
    autoDownload,
    autoDownloadLimit,
    autoDeletePlayedDays,
    playbackSpeedOverride,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SubscriptionRow &&
          other.id == this.id &&
          other.title == this.title &&
          other.author == this.author &&
          other.feedUrl == this.feedUrl &&
          other.artworkUrl == this.artworkUrl &&
          other.genre == this.genre &&
          other.episodeCount == this.episodeCount &&
          other.subscribedAt == this.subscribedAt &&
          other.lastRefreshedAt == this.lastRefreshedAt &&
          other.autoDownload == this.autoDownload &&
          other.autoDownloadLimit == this.autoDownloadLimit &&
          other.autoDeletePlayedDays == this.autoDeletePlayedDays &&
          other.playbackSpeedOverride == this.playbackSpeedOverride);
}

class SubscriptionsCompanion extends UpdateCompanion<SubscriptionRow> {
  final Value<int> id;
  final Value<String> title;
  final Value<String> author;
  final Value<String> feedUrl;
  final Value<String?> artworkUrl;
  final Value<String?> genre;
  final Value<int> episodeCount;
  final Value<DateTime> subscribedAt;
  final Value<DateTime?> lastRefreshedAt;
  final Value<String> autoDownload;
  final Value<int> autoDownloadLimit;
  final Value<int> autoDeletePlayedDays;
  final Value<double?> playbackSpeedOverride;
  const SubscriptionsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.author = const Value.absent(),
    this.feedUrl = const Value.absent(),
    this.artworkUrl = const Value.absent(),
    this.genre = const Value.absent(),
    this.episodeCount = const Value.absent(),
    this.subscribedAt = const Value.absent(),
    this.lastRefreshedAt = const Value.absent(),
    this.autoDownload = const Value.absent(),
    this.autoDownloadLimit = const Value.absent(),
    this.autoDeletePlayedDays = const Value.absent(),
    this.playbackSpeedOverride = const Value.absent(),
  });
  SubscriptionsCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required String author,
    required String feedUrl,
    this.artworkUrl = const Value.absent(),
    this.genre = const Value.absent(),
    this.episodeCount = const Value.absent(),
    this.subscribedAt = const Value.absent(),
    this.lastRefreshedAt = const Value.absent(),
    this.autoDownload = const Value.absent(),
    this.autoDownloadLimit = const Value.absent(),
    this.autoDeletePlayedDays = const Value.absent(),
    this.playbackSpeedOverride = const Value.absent(),
  }) : title = Value(title),
       author = Value(author),
       feedUrl = Value(feedUrl);
  static Insertable<SubscriptionRow> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? author,
    Expression<String>? feedUrl,
    Expression<String>? artworkUrl,
    Expression<String>? genre,
    Expression<int>? episodeCount,
    Expression<DateTime>? subscribedAt,
    Expression<DateTime>? lastRefreshedAt,
    Expression<String>? autoDownload,
    Expression<int>? autoDownloadLimit,
    Expression<int>? autoDeletePlayedDays,
    Expression<double>? playbackSpeedOverride,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (author != null) 'author': author,
      if (feedUrl != null) 'feed_url': feedUrl,
      if (artworkUrl != null) 'artwork_url': artworkUrl,
      if (genre != null) 'genre': genre,
      if (episodeCount != null) 'episode_count': episodeCount,
      if (subscribedAt != null) 'subscribed_at': subscribedAt,
      if (lastRefreshedAt != null) 'last_refreshed_at': lastRefreshedAt,
      if (autoDownload != null) 'auto_download': autoDownload,
      if (autoDownloadLimit != null) 'auto_download_limit': autoDownloadLimit,
      if (autoDeletePlayedDays != null)
        'auto_delete_played_days': autoDeletePlayedDays,
      if (playbackSpeedOverride != null)
        'playback_speed_override': playbackSpeedOverride,
    });
  }

  SubscriptionsCompanion copyWith({
    Value<int>? id,
    Value<String>? title,
    Value<String>? author,
    Value<String>? feedUrl,
    Value<String?>? artworkUrl,
    Value<String?>? genre,
    Value<int>? episodeCount,
    Value<DateTime>? subscribedAt,
    Value<DateTime?>? lastRefreshedAt,
    Value<String>? autoDownload,
    Value<int>? autoDownloadLimit,
    Value<int>? autoDeletePlayedDays,
    Value<double?>? playbackSpeedOverride,
  }) {
    return SubscriptionsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      feedUrl: feedUrl ?? this.feedUrl,
      artworkUrl: artworkUrl ?? this.artworkUrl,
      genre: genre ?? this.genre,
      episodeCount: episodeCount ?? this.episodeCount,
      subscribedAt: subscribedAt ?? this.subscribedAt,
      lastRefreshedAt: lastRefreshedAt ?? this.lastRefreshedAt,
      autoDownload: autoDownload ?? this.autoDownload,
      autoDownloadLimit: autoDownloadLimit ?? this.autoDownloadLimit,
      autoDeletePlayedDays: autoDeletePlayedDays ?? this.autoDeletePlayedDays,
      playbackSpeedOverride:
          playbackSpeedOverride ?? this.playbackSpeedOverride,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (author.present) {
      map['author'] = Variable<String>(author.value);
    }
    if (feedUrl.present) {
      map['feed_url'] = Variable<String>(feedUrl.value);
    }
    if (artworkUrl.present) {
      map['artwork_url'] = Variable<String>(artworkUrl.value);
    }
    if (genre.present) {
      map['genre'] = Variable<String>(genre.value);
    }
    if (episodeCount.present) {
      map['episode_count'] = Variable<int>(episodeCount.value);
    }
    if (subscribedAt.present) {
      map['subscribed_at'] = Variable<DateTime>(subscribedAt.value);
    }
    if (lastRefreshedAt.present) {
      map['last_refreshed_at'] = Variable<DateTime>(lastRefreshedAt.value);
    }
    if (autoDownload.present) {
      map['auto_download'] = Variable<String>(autoDownload.value);
    }
    if (autoDownloadLimit.present) {
      map['auto_download_limit'] = Variable<int>(autoDownloadLimit.value);
    }
    if (autoDeletePlayedDays.present) {
      map['auto_delete_played_days'] = Variable<int>(
        autoDeletePlayedDays.value,
      );
    }
    if (playbackSpeedOverride.present) {
      map['playback_speed_override'] = Variable<double>(
        playbackSpeedOverride.value,
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SubscriptionsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('author: $author, ')
          ..write('feedUrl: $feedUrl, ')
          ..write('artworkUrl: $artworkUrl, ')
          ..write('genre: $genre, ')
          ..write('episodeCount: $episodeCount, ')
          ..write('subscribedAt: $subscribedAt, ')
          ..write('lastRefreshedAt: $lastRefreshedAt, ')
          ..write('autoDownload: $autoDownload, ')
          ..write('autoDownloadLimit: $autoDownloadLimit, ')
          ..write('autoDeletePlayedDays: $autoDeletePlayedDays, ')
          ..write('playbackSpeedOverride: $playbackSpeedOverride')
          ..write(')'))
        .toString();
  }
}

class $EpisodeCacheTable extends EpisodeCache
    with TableInfo<$EpisodeCacheTable, EpisodeCacheRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EpisodeCacheTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _podcastIdMeta = const VerificationMeta(
    'podcastId',
  );
  @override
  late final GeneratedColumn<int> podcastId = GeneratedColumn<int>(
    'podcast_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES subscriptions (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _guidMeta = const VerificationMeta('guid');
  @override
  late final GeneratedColumn<String> guid = GeneratedColumn<String>(
    'guid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _audioUrlMeta = const VerificationMeta(
    'audioUrl',
  );
  @override
  late final GeneratedColumn<String> audioUrl = GeneratedColumn<String>(
    'audio_url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _imageUrlMeta = const VerificationMeta(
    'imageUrl',
  );
  @override
  late final GeneratedColumn<String> imageUrl = GeneratedColumn<String>(
    'image_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _durationSecondsMeta = const VerificationMeta(
    'durationSeconds',
  );
  @override
  late final GeneratedColumn<int> durationSeconds = GeneratedColumn<int>(
    'duration_seconds',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _publishedAtMeta = const VerificationMeta(
    'publishedAt',
  );
  @override
  late final GeneratedColumn<DateTime> publishedAt = GeneratedColumn<DateTime>(
    'published_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _addedAtMeta = const VerificationMeta(
    'addedAt',
  );
  @override
  late final GeneratedColumn<DateTime> addedAt = GeneratedColumn<DateTime>(
    'added_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _archivedMeta = const VerificationMeta(
    'archived',
  );
  @override
  late final GeneratedColumn<bool> archived = GeneratedColumn<bool>(
    'archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _seasonNumberMeta = const VerificationMeta(
    'seasonNumber',
  );
  @override
  late final GeneratedColumn<int> seasonNumber = GeneratedColumn<int>(
    'season_number',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _episodeNumberMeta = const VerificationMeta(
    'episodeNumber',
  );
  @override
  late final GeneratedColumn<int> episodeNumber = GeneratedColumn<int>(
    'episode_number',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _episodeTypeMeta = const VerificationMeta(
    'episodeType',
  );
  @override
  late final GeneratedColumn<String> episodeType = GeneratedColumn<String>(
    'episode_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _linkMeta = const VerificationMeta('link');
  @override
  late final GeneratedColumn<String> link = GeneratedColumn<String>(
    'link',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _chaptersUrlMeta = const VerificationMeta(
    'chaptersUrl',
  );
  @override
  late final GeneratedColumn<String> chaptersUrl = GeneratedColumn<String>(
    'chapters_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    podcastId,
    guid,
    title,
    audioUrl,
    description,
    imageUrl,
    durationSeconds,
    publishedAt,
    addedAt,
    archived,
    seasonNumber,
    episodeNumber,
    episodeType,
    link,
    chaptersUrl,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'episode_cache';
  @override
  VerificationContext validateIntegrity(
    Insertable<EpisodeCacheRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('podcast_id')) {
      context.handle(
        _podcastIdMeta,
        podcastId.isAcceptableOrUnknown(data['podcast_id']!, _podcastIdMeta),
      );
    } else if (isInserting) {
      context.missing(_podcastIdMeta);
    }
    if (data.containsKey('guid')) {
      context.handle(
        _guidMeta,
        guid.isAcceptableOrUnknown(data['guid']!, _guidMeta),
      );
    } else if (isInserting) {
      context.missing(_guidMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('audio_url')) {
      context.handle(
        _audioUrlMeta,
        audioUrl.isAcceptableOrUnknown(data['audio_url']!, _audioUrlMeta),
      );
    } else if (isInserting) {
      context.missing(_audioUrlMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('image_url')) {
      context.handle(
        _imageUrlMeta,
        imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta),
      );
    }
    if (data.containsKey('duration_seconds')) {
      context.handle(
        _durationSecondsMeta,
        durationSeconds.isAcceptableOrUnknown(
          data['duration_seconds']!,
          _durationSecondsMeta,
        ),
      );
    }
    if (data.containsKey('published_at')) {
      context.handle(
        _publishedAtMeta,
        publishedAt.isAcceptableOrUnknown(
          data['published_at']!,
          _publishedAtMeta,
        ),
      );
    }
    if (data.containsKey('added_at')) {
      context.handle(
        _addedAtMeta,
        addedAt.isAcceptableOrUnknown(data['added_at']!, _addedAtMeta),
      );
    }
    if (data.containsKey('archived')) {
      context.handle(
        _archivedMeta,
        archived.isAcceptableOrUnknown(data['archived']!, _archivedMeta),
      );
    }
    if (data.containsKey('season_number')) {
      context.handle(
        _seasonNumberMeta,
        seasonNumber.isAcceptableOrUnknown(
          data['season_number']!,
          _seasonNumberMeta,
        ),
      );
    }
    if (data.containsKey('episode_number')) {
      context.handle(
        _episodeNumberMeta,
        episodeNumber.isAcceptableOrUnknown(
          data['episode_number']!,
          _episodeNumberMeta,
        ),
      );
    }
    if (data.containsKey('episode_type')) {
      context.handle(
        _episodeTypeMeta,
        episodeType.isAcceptableOrUnknown(
          data['episode_type']!,
          _episodeTypeMeta,
        ),
      );
    }
    if (data.containsKey('link')) {
      context.handle(
        _linkMeta,
        link.isAcceptableOrUnknown(data['link']!, _linkMeta),
      );
    }
    if (data.containsKey('chapters_url')) {
      context.handle(
        _chaptersUrlMeta,
        chaptersUrl.isAcceptableOrUnknown(
          data['chapters_url']!,
          _chaptersUrlMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {podcastId, guid};
  @override
  EpisodeCacheRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EpisodeCacheRow(
      podcastId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}podcast_id'],
      )!,
      guid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}guid'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      audioUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}audio_url'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      imageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_url'],
      ),
      durationSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_seconds'],
      ),
      publishedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}published_at'],
      ),
      addedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}added_at'],
      ),
      archived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}archived'],
      )!,
      seasonNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}season_number'],
      ),
      episodeNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}episode_number'],
      ),
      episodeType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}episode_type'],
      ),
      link: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}link'],
      ),
      chaptersUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}chapters_url'],
      ),
    );
  }

  @override
  $EpisodeCacheTable createAlias(String alias) {
    return $EpisodeCacheTable(attachedDatabase, alias);
  }
}

class EpisodeCacheRow extends DataClass implements Insertable<EpisodeCacheRow> {
  final int podcastId;
  final String guid;
  final String title;
  final String audioUrl;
  final String? description;
  final String? imageUrl;
  final int? durationSeconds;
  final DateTime? publishedAt;

  /// Quando o episódio entrou no cache local (Fase 9). `null` = já estava
  /// no cache antes da v3 (não dá pra saber). Feeds mentem `publishedAt`;
  /// quando presente, isto é confiável pra "novos desde a última visita".
  /// Nullable de propósito: SQLite não deixa `ADD COLUMN NOT NULL` com
  /// default de expressão — quem preenche em INSERT é o `LibraryRepository`.
  final DateTime? addedAt;

  /// Arquivado (Fase 13) — some das listas mas não desassina nem apaga o
  /// cache. Default `false` = comportamento atual.
  final bool archived;

  /// Metadados avançados do feed (Fase 14). Todos nullable: feed antigo /
  /// linha antiga simplesmente não tem, e `ADD COLUMN NOT NULL` com default
  /// de expressão trava a migração.
  final int? seasonNumber;
  final int? episodeNumber;

  /// `full` | `trailer` | `bonus` (itunes:episodeType). `null` = o feed não
  /// declarou.
  final String? episodeType;

  /// `<link>` do item — página do episódio no site do podcast.
  final String? link;

  /// URL do JSON de capítulos (`<podcast:chapters url="...">`). Quem baixa e
  /// persiste é o `ChapterService`.
  final String? chaptersUrl;
  const EpisodeCacheRow({
    required this.podcastId,
    required this.guid,
    required this.title,
    required this.audioUrl,
    this.description,
    this.imageUrl,
    this.durationSeconds,
    this.publishedAt,
    this.addedAt,
    required this.archived,
    this.seasonNumber,
    this.episodeNumber,
    this.episodeType,
    this.link,
    this.chaptersUrl,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['podcast_id'] = Variable<int>(podcastId);
    map['guid'] = Variable<String>(guid);
    map['title'] = Variable<String>(title);
    map['audio_url'] = Variable<String>(audioUrl);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || imageUrl != null) {
      map['image_url'] = Variable<String>(imageUrl);
    }
    if (!nullToAbsent || durationSeconds != null) {
      map['duration_seconds'] = Variable<int>(durationSeconds);
    }
    if (!nullToAbsent || publishedAt != null) {
      map['published_at'] = Variable<DateTime>(publishedAt);
    }
    if (!nullToAbsent || addedAt != null) {
      map['added_at'] = Variable<DateTime>(addedAt);
    }
    map['archived'] = Variable<bool>(archived);
    if (!nullToAbsent || seasonNumber != null) {
      map['season_number'] = Variable<int>(seasonNumber);
    }
    if (!nullToAbsent || episodeNumber != null) {
      map['episode_number'] = Variable<int>(episodeNumber);
    }
    if (!nullToAbsent || episodeType != null) {
      map['episode_type'] = Variable<String>(episodeType);
    }
    if (!nullToAbsent || link != null) {
      map['link'] = Variable<String>(link);
    }
    if (!nullToAbsent || chaptersUrl != null) {
      map['chapters_url'] = Variable<String>(chaptersUrl);
    }
    return map;
  }

  EpisodeCacheCompanion toCompanion(bool nullToAbsent) {
    return EpisodeCacheCompanion(
      podcastId: Value(podcastId),
      guid: Value(guid),
      title: Value(title),
      audioUrl: Value(audioUrl),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      imageUrl: imageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(imageUrl),
      durationSeconds: durationSeconds == null && nullToAbsent
          ? const Value.absent()
          : Value(durationSeconds),
      publishedAt: publishedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(publishedAt),
      addedAt: addedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(addedAt),
      archived: Value(archived),
      seasonNumber: seasonNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(seasonNumber),
      episodeNumber: episodeNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(episodeNumber),
      episodeType: episodeType == null && nullToAbsent
          ? const Value.absent()
          : Value(episodeType),
      link: link == null && nullToAbsent ? const Value.absent() : Value(link),
      chaptersUrl: chaptersUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(chaptersUrl),
    );
  }

  factory EpisodeCacheRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EpisodeCacheRow(
      podcastId: serializer.fromJson<int>(json['podcastId']),
      guid: serializer.fromJson<String>(json['guid']),
      title: serializer.fromJson<String>(json['title']),
      audioUrl: serializer.fromJson<String>(json['audioUrl']),
      description: serializer.fromJson<String?>(json['description']),
      imageUrl: serializer.fromJson<String?>(json['imageUrl']),
      durationSeconds: serializer.fromJson<int?>(json['durationSeconds']),
      publishedAt: serializer.fromJson<DateTime?>(json['publishedAt']),
      addedAt: serializer.fromJson<DateTime?>(json['addedAt']),
      archived: serializer.fromJson<bool>(json['archived']),
      seasonNumber: serializer.fromJson<int?>(json['seasonNumber']),
      episodeNumber: serializer.fromJson<int?>(json['episodeNumber']),
      episodeType: serializer.fromJson<String?>(json['episodeType']),
      link: serializer.fromJson<String?>(json['link']),
      chaptersUrl: serializer.fromJson<String?>(json['chaptersUrl']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'podcastId': serializer.toJson<int>(podcastId),
      'guid': serializer.toJson<String>(guid),
      'title': serializer.toJson<String>(title),
      'audioUrl': serializer.toJson<String>(audioUrl),
      'description': serializer.toJson<String?>(description),
      'imageUrl': serializer.toJson<String?>(imageUrl),
      'durationSeconds': serializer.toJson<int?>(durationSeconds),
      'publishedAt': serializer.toJson<DateTime?>(publishedAt),
      'addedAt': serializer.toJson<DateTime?>(addedAt),
      'archived': serializer.toJson<bool>(archived),
      'seasonNumber': serializer.toJson<int?>(seasonNumber),
      'episodeNumber': serializer.toJson<int?>(episodeNumber),
      'episodeType': serializer.toJson<String?>(episodeType),
      'link': serializer.toJson<String?>(link),
      'chaptersUrl': serializer.toJson<String?>(chaptersUrl),
    };
  }

  EpisodeCacheRow copyWith({
    int? podcastId,
    String? guid,
    String? title,
    String? audioUrl,
    Value<String?> description = const Value.absent(),
    Value<String?> imageUrl = const Value.absent(),
    Value<int?> durationSeconds = const Value.absent(),
    Value<DateTime?> publishedAt = const Value.absent(),
    Value<DateTime?> addedAt = const Value.absent(),
    bool? archived,
    Value<int?> seasonNumber = const Value.absent(),
    Value<int?> episodeNumber = const Value.absent(),
    Value<String?> episodeType = const Value.absent(),
    Value<String?> link = const Value.absent(),
    Value<String?> chaptersUrl = const Value.absent(),
  }) => EpisodeCacheRow(
    podcastId: podcastId ?? this.podcastId,
    guid: guid ?? this.guid,
    title: title ?? this.title,
    audioUrl: audioUrl ?? this.audioUrl,
    description: description.present ? description.value : this.description,
    imageUrl: imageUrl.present ? imageUrl.value : this.imageUrl,
    durationSeconds: durationSeconds.present
        ? durationSeconds.value
        : this.durationSeconds,
    publishedAt: publishedAt.present ? publishedAt.value : this.publishedAt,
    addedAt: addedAt.present ? addedAt.value : this.addedAt,
    archived: archived ?? this.archived,
    seasonNumber: seasonNumber.present ? seasonNumber.value : this.seasonNumber,
    episodeNumber: episodeNumber.present
        ? episodeNumber.value
        : this.episodeNumber,
    episodeType: episodeType.present ? episodeType.value : this.episodeType,
    link: link.present ? link.value : this.link,
    chaptersUrl: chaptersUrl.present ? chaptersUrl.value : this.chaptersUrl,
  );
  EpisodeCacheRow copyWithCompanion(EpisodeCacheCompanion data) {
    return EpisodeCacheRow(
      podcastId: data.podcastId.present ? data.podcastId.value : this.podcastId,
      guid: data.guid.present ? data.guid.value : this.guid,
      title: data.title.present ? data.title.value : this.title,
      audioUrl: data.audioUrl.present ? data.audioUrl.value : this.audioUrl,
      description: data.description.present
          ? data.description.value
          : this.description,
      imageUrl: data.imageUrl.present ? data.imageUrl.value : this.imageUrl,
      durationSeconds: data.durationSeconds.present
          ? data.durationSeconds.value
          : this.durationSeconds,
      publishedAt: data.publishedAt.present
          ? data.publishedAt.value
          : this.publishedAt,
      addedAt: data.addedAt.present ? data.addedAt.value : this.addedAt,
      archived: data.archived.present ? data.archived.value : this.archived,
      seasonNumber: data.seasonNumber.present
          ? data.seasonNumber.value
          : this.seasonNumber,
      episodeNumber: data.episodeNumber.present
          ? data.episodeNumber.value
          : this.episodeNumber,
      episodeType: data.episodeType.present
          ? data.episodeType.value
          : this.episodeType,
      link: data.link.present ? data.link.value : this.link,
      chaptersUrl: data.chaptersUrl.present
          ? data.chaptersUrl.value
          : this.chaptersUrl,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EpisodeCacheRow(')
          ..write('podcastId: $podcastId, ')
          ..write('guid: $guid, ')
          ..write('title: $title, ')
          ..write('audioUrl: $audioUrl, ')
          ..write('description: $description, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('publishedAt: $publishedAt, ')
          ..write('addedAt: $addedAt, ')
          ..write('archived: $archived, ')
          ..write('seasonNumber: $seasonNumber, ')
          ..write('episodeNumber: $episodeNumber, ')
          ..write('episodeType: $episodeType, ')
          ..write('link: $link, ')
          ..write('chaptersUrl: $chaptersUrl')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    podcastId,
    guid,
    title,
    audioUrl,
    description,
    imageUrl,
    durationSeconds,
    publishedAt,
    addedAt,
    archived,
    seasonNumber,
    episodeNumber,
    episodeType,
    link,
    chaptersUrl,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EpisodeCacheRow &&
          other.podcastId == this.podcastId &&
          other.guid == this.guid &&
          other.title == this.title &&
          other.audioUrl == this.audioUrl &&
          other.description == this.description &&
          other.imageUrl == this.imageUrl &&
          other.durationSeconds == this.durationSeconds &&
          other.publishedAt == this.publishedAt &&
          other.addedAt == this.addedAt &&
          other.archived == this.archived &&
          other.seasonNumber == this.seasonNumber &&
          other.episodeNumber == this.episodeNumber &&
          other.episodeType == this.episodeType &&
          other.link == this.link &&
          other.chaptersUrl == this.chaptersUrl);
}

class EpisodeCacheCompanion extends UpdateCompanion<EpisodeCacheRow> {
  final Value<int> podcastId;
  final Value<String> guid;
  final Value<String> title;
  final Value<String> audioUrl;
  final Value<String?> description;
  final Value<String?> imageUrl;
  final Value<int?> durationSeconds;
  final Value<DateTime?> publishedAt;
  final Value<DateTime?> addedAt;
  final Value<bool> archived;
  final Value<int?> seasonNumber;
  final Value<int?> episodeNumber;
  final Value<String?> episodeType;
  final Value<String?> link;
  final Value<String?> chaptersUrl;
  final Value<int> rowid;
  const EpisodeCacheCompanion({
    this.podcastId = const Value.absent(),
    this.guid = const Value.absent(),
    this.title = const Value.absent(),
    this.audioUrl = const Value.absent(),
    this.description = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.durationSeconds = const Value.absent(),
    this.publishedAt = const Value.absent(),
    this.addedAt = const Value.absent(),
    this.archived = const Value.absent(),
    this.seasonNumber = const Value.absent(),
    this.episodeNumber = const Value.absent(),
    this.episodeType = const Value.absent(),
    this.link = const Value.absent(),
    this.chaptersUrl = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EpisodeCacheCompanion.insert({
    required int podcastId,
    required String guid,
    required String title,
    required String audioUrl,
    this.description = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.durationSeconds = const Value.absent(),
    this.publishedAt = const Value.absent(),
    this.addedAt = const Value.absent(),
    this.archived = const Value.absent(),
    this.seasonNumber = const Value.absent(),
    this.episodeNumber = const Value.absent(),
    this.episodeType = const Value.absent(),
    this.link = const Value.absent(),
    this.chaptersUrl = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : podcastId = Value(podcastId),
       guid = Value(guid),
       title = Value(title),
       audioUrl = Value(audioUrl);
  static Insertable<EpisodeCacheRow> custom({
    Expression<int>? podcastId,
    Expression<String>? guid,
    Expression<String>? title,
    Expression<String>? audioUrl,
    Expression<String>? description,
    Expression<String>? imageUrl,
    Expression<int>? durationSeconds,
    Expression<DateTime>? publishedAt,
    Expression<DateTime>? addedAt,
    Expression<bool>? archived,
    Expression<int>? seasonNumber,
    Expression<int>? episodeNumber,
    Expression<String>? episodeType,
    Expression<String>? link,
    Expression<String>? chaptersUrl,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (podcastId != null) 'podcast_id': podcastId,
      if (guid != null) 'guid': guid,
      if (title != null) 'title': title,
      if (audioUrl != null) 'audio_url': audioUrl,
      if (description != null) 'description': description,
      if (imageUrl != null) 'image_url': imageUrl,
      if (durationSeconds != null) 'duration_seconds': durationSeconds,
      if (publishedAt != null) 'published_at': publishedAt,
      if (addedAt != null) 'added_at': addedAt,
      if (archived != null) 'archived': archived,
      if (seasonNumber != null) 'season_number': seasonNumber,
      if (episodeNumber != null) 'episode_number': episodeNumber,
      if (episodeType != null) 'episode_type': episodeType,
      if (link != null) 'link': link,
      if (chaptersUrl != null) 'chapters_url': chaptersUrl,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EpisodeCacheCompanion copyWith({
    Value<int>? podcastId,
    Value<String>? guid,
    Value<String>? title,
    Value<String>? audioUrl,
    Value<String?>? description,
    Value<String?>? imageUrl,
    Value<int?>? durationSeconds,
    Value<DateTime?>? publishedAt,
    Value<DateTime?>? addedAt,
    Value<bool>? archived,
    Value<int?>? seasonNumber,
    Value<int?>? episodeNumber,
    Value<String?>? episodeType,
    Value<String?>? link,
    Value<String?>? chaptersUrl,
    Value<int>? rowid,
  }) {
    return EpisodeCacheCompanion(
      podcastId: podcastId ?? this.podcastId,
      guid: guid ?? this.guid,
      title: title ?? this.title,
      audioUrl: audioUrl ?? this.audioUrl,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      publishedAt: publishedAt ?? this.publishedAt,
      addedAt: addedAt ?? this.addedAt,
      archived: archived ?? this.archived,
      seasonNumber: seasonNumber ?? this.seasonNumber,
      episodeNumber: episodeNumber ?? this.episodeNumber,
      episodeType: episodeType ?? this.episodeType,
      link: link ?? this.link,
      chaptersUrl: chaptersUrl ?? this.chaptersUrl,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (podcastId.present) {
      map['podcast_id'] = Variable<int>(podcastId.value);
    }
    if (guid.present) {
      map['guid'] = Variable<String>(guid.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (audioUrl.present) {
      map['audio_url'] = Variable<String>(audioUrl.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    if (durationSeconds.present) {
      map['duration_seconds'] = Variable<int>(durationSeconds.value);
    }
    if (publishedAt.present) {
      map['published_at'] = Variable<DateTime>(publishedAt.value);
    }
    if (addedAt.present) {
      map['added_at'] = Variable<DateTime>(addedAt.value);
    }
    if (archived.present) {
      map['archived'] = Variable<bool>(archived.value);
    }
    if (seasonNumber.present) {
      map['season_number'] = Variable<int>(seasonNumber.value);
    }
    if (episodeNumber.present) {
      map['episode_number'] = Variable<int>(episodeNumber.value);
    }
    if (episodeType.present) {
      map['episode_type'] = Variable<String>(episodeType.value);
    }
    if (link.present) {
      map['link'] = Variable<String>(link.value);
    }
    if (chaptersUrl.present) {
      map['chapters_url'] = Variable<String>(chaptersUrl.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EpisodeCacheCompanion(')
          ..write('podcastId: $podcastId, ')
          ..write('guid: $guid, ')
          ..write('title: $title, ')
          ..write('audioUrl: $audioUrl, ')
          ..write('description: $description, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('publishedAt: $publishedAt, ')
          ..write('addedAt: $addedAt, ')
          ..write('archived: $archived, ')
          ..write('seasonNumber: $seasonNumber, ')
          ..write('episodeNumber: $episodeNumber, ')
          ..write('episodeType: $episodeType, ')
          ..write('link: $link, ')
          ..write('chaptersUrl: $chaptersUrl, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PlaybackProgressTable extends PlaybackProgress
    with TableInfo<$PlaybackProgressTable, PlaybackProgressRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlaybackProgressTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _podcastIdMeta = const VerificationMeta(
    'podcastId',
  );
  @override
  late final GeneratedColumn<int> podcastId = GeneratedColumn<int>(
    'podcast_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES subscriptions (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _episodeGuidMeta = const VerificationMeta(
    'episodeGuid',
  );
  @override
  late final GeneratedColumn<String> episodeGuid = GeneratedColumn<String>(
    'episode_guid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _positionSecondsMeta = const VerificationMeta(
    'positionSeconds',
  );
  @override
  late final GeneratedColumn<int> positionSeconds = GeneratedColumn<int>(
    'position_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _completedMeta = const VerificationMeta(
    'completed',
  );
  @override
  late final GeneratedColumn<bool> completed = GeneratedColumn<bool>(
    'completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    podcastId,
    episodeGuid,
    positionSeconds,
    completed,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'playback_progress';
  @override
  VerificationContext validateIntegrity(
    Insertable<PlaybackProgressRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('podcast_id')) {
      context.handle(
        _podcastIdMeta,
        podcastId.isAcceptableOrUnknown(data['podcast_id']!, _podcastIdMeta),
      );
    } else if (isInserting) {
      context.missing(_podcastIdMeta);
    }
    if (data.containsKey('episode_guid')) {
      context.handle(
        _episodeGuidMeta,
        episodeGuid.isAcceptableOrUnknown(
          data['episode_guid']!,
          _episodeGuidMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_episodeGuidMeta);
    }
    if (data.containsKey('position_seconds')) {
      context.handle(
        _positionSecondsMeta,
        positionSeconds.isAcceptableOrUnknown(
          data['position_seconds']!,
          _positionSecondsMeta,
        ),
      );
    }
    if (data.containsKey('completed')) {
      context.handle(
        _completedMeta,
        completed.isAcceptableOrUnknown(data['completed']!, _completedMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {podcastId, episodeGuid};
  @override
  PlaybackProgressRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlaybackProgressRow(
      podcastId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}podcast_id'],
      )!,
      episodeGuid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}episode_guid'],
      )!,
      positionSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position_seconds'],
      )!,
      completed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}completed'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $PlaybackProgressTable createAlias(String alias) {
    return $PlaybackProgressTable(attachedDatabase, alias);
  }
}

class PlaybackProgressRow extends DataClass
    implements Insertable<PlaybackProgressRow> {
  final int podcastId;
  final String episodeGuid;
  final int positionSeconds;
  final bool completed;
  final DateTime updatedAt;
  const PlaybackProgressRow({
    required this.podcastId,
    required this.episodeGuid,
    required this.positionSeconds,
    required this.completed,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['podcast_id'] = Variable<int>(podcastId);
    map['episode_guid'] = Variable<String>(episodeGuid);
    map['position_seconds'] = Variable<int>(positionSeconds);
    map['completed'] = Variable<bool>(completed);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  PlaybackProgressCompanion toCompanion(bool nullToAbsent) {
    return PlaybackProgressCompanion(
      podcastId: Value(podcastId),
      episodeGuid: Value(episodeGuid),
      positionSeconds: Value(positionSeconds),
      completed: Value(completed),
      updatedAt: Value(updatedAt),
    );
  }

  factory PlaybackProgressRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlaybackProgressRow(
      podcastId: serializer.fromJson<int>(json['podcastId']),
      episodeGuid: serializer.fromJson<String>(json['episodeGuid']),
      positionSeconds: serializer.fromJson<int>(json['positionSeconds']),
      completed: serializer.fromJson<bool>(json['completed']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'podcastId': serializer.toJson<int>(podcastId),
      'episodeGuid': serializer.toJson<String>(episodeGuid),
      'positionSeconds': serializer.toJson<int>(positionSeconds),
      'completed': serializer.toJson<bool>(completed),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  PlaybackProgressRow copyWith({
    int? podcastId,
    String? episodeGuid,
    int? positionSeconds,
    bool? completed,
    DateTime? updatedAt,
  }) => PlaybackProgressRow(
    podcastId: podcastId ?? this.podcastId,
    episodeGuid: episodeGuid ?? this.episodeGuid,
    positionSeconds: positionSeconds ?? this.positionSeconds,
    completed: completed ?? this.completed,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  PlaybackProgressRow copyWithCompanion(PlaybackProgressCompanion data) {
    return PlaybackProgressRow(
      podcastId: data.podcastId.present ? data.podcastId.value : this.podcastId,
      episodeGuid: data.episodeGuid.present
          ? data.episodeGuid.value
          : this.episodeGuid,
      positionSeconds: data.positionSeconds.present
          ? data.positionSeconds.value
          : this.positionSeconds,
      completed: data.completed.present ? data.completed.value : this.completed,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlaybackProgressRow(')
          ..write('podcastId: $podcastId, ')
          ..write('episodeGuid: $episodeGuid, ')
          ..write('positionSeconds: $positionSeconds, ')
          ..write('completed: $completed, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    podcastId,
    episodeGuid,
    positionSeconds,
    completed,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlaybackProgressRow &&
          other.podcastId == this.podcastId &&
          other.episodeGuid == this.episodeGuid &&
          other.positionSeconds == this.positionSeconds &&
          other.completed == this.completed &&
          other.updatedAt == this.updatedAt);
}

class PlaybackProgressCompanion extends UpdateCompanion<PlaybackProgressRow> {
  final Value<int> podcastId;
  final Value<String> episodeGuid;
  final Value<int> positionSeconds;
  final Value<bool> completed;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const PlaybackProgressCompanion({
    this.podcastId = const Value.absent(),
    this.episodeGuid = const Value.absent(),
    this.positionSeconds = const Value.absent(),
    this.completed = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PlaybackProgressCompanion.insert({
    required int podcastId,
    required String episodeGuid,
    this.positionSeconds = const Value.absent(),
    this.completed = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : podcastId = Value(podcastId),
       episodeGuid = Value(episodeGuid);
  static Insertable<PlaybackProgressRow> custom({
    Expression<int>? podcastId,
    Expression<String>? episodeGuid,
    Expression<int>? positionSeconds,
    Expression<bool>? completed,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (podcastId != null) 'podcast_id': podcastId,
      if (episodeGuid != null) 'episode_guid': episodeGuid,
      if (positionSeconds != null) 'position_seconds': positionSeconds,
      if (completed != null) 'completed': completed,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PlaybackProgressCompanion copyWith({
    Value<int>? podcastId,
    Value<String>? episodeGuid,
    Value<int>? positionSeconds,
    Value<bool>? completed,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return PlaybackProgressCompanion(
      podcastId: podcastId ?? this.podcastId,
      episodeGuid: episodeGuid ?? this.episodeGuid,
      positionSeconds: positionSeconds ?? this.positionSeconds,
      completed: completed ?? this.completed,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (podcastId.present) {
      map['podcast_id'] = Variable<int>(podcastId.value);
    }
    if (episodeGuid.present) {
      map['episode_guid'] = Variable<String>(episodeGuid.value);
    }
    if (positionSeconds.present) {
      map['position_seconds'] = Variable<int>(positionSeconds.value);
    }
    if (completed.present) {
      map['completed'] = Variable<bool>(completed.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlaybackProgressCompanion(')
          ..write('podcastId: $podcastId, ')
          ..write('episodeGuid: $episodeGuid, ')
          ..write('positionSeconds: $positionSeconds, ')
          ..write('completed: $completed, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DownloadsTable extends Downloads
    with TableInfo<$DownloadsTable, DownloadRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DownloadsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _podcastIdMeta = const VerificationMeta(
    'podcastId',
  );
  @override
  late final GeneratedColumn<int> podcastId = GeneratedColumn<int>(
    'podcast_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES subscriptions (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _episodeGuidMeta = const VerificationMeta(
    'episodeGuid',
  );
  @override
  late final GeneratedColumn<String> episodeGuid = GeneratedColumn<String>(
    'episode_guid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<String> taskId = GeneratedColumn<String>(
    'task_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _localPathMeta = const VerificationMeta(
    'localPath',
  );
  @override
  late final GeneratedColumn<String> localPath = GeneratedColumn<String>(
    'local_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('queued'),
  );
  static const VerificationMeta _progressMeta = const VerificationMeta(
    'progress',
  );
  @override
  late final GeneratedColumn<int> progress = GeneratedColumn<int>(
    'progress',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    podcastId,
    episodeGuid,
    taskId,
    localPath,
    status,
    progress,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'downloads';
  @override
  VerificationContext validateIntegrity(
    Insertable<DownloadRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('podcast_id')) {
      context.handle(
        _podcastIdMeta,
        podcastId.isAcceptableOrUnknown(data['podcast_id']!, _podcastIdMeta),
      );
    } else if (isInserting) {
      context.missing(_podcastIdMeta);
    }
    if (data.containsKey('episode_guid')) {
      context.handle(
        _episodeGuidMeta,
        episodeGuid.isAcceptableOrUnknown(
          data['episode_guid']!,
          _episodeGuidMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_episodeGuidMeta);
    }
    if (data.containsKey('task_id')) {
      context.handle(
        _taskIdMeta,
        taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta),
      );
    }
    if (data.containsKey('local_path')) {
      context.handle(
        _localPathMeta,
        localPath.isAcceptableOrUnknown(data['local_path']!, _localPathMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('progress')) {
      context.handle(
        _progressMeta,
        progress.isAcceptableOrUnknown(data['progress']!, _progressMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {podcastId, episodeGuid};
  @override
  DownloadRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DownloadRow(
      podcastId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}podcast_id'],
      )!,
      episodeGuid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}episode_guid'],
      )!,
      taskId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}task_id'],
      ),
      localPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_path'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      progress: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}progress'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $DownloadsTable createAlias(String alias) {
    return $DownloadsTable(attachedDatabase, alias);
  }
}

class DownloadRow extends DataClass implements Insertable<DownloadRow> {
  final int podcastId;
  final String episodeGuid;
  final String? taskId;
  final String? localPath;
  final String status;
  final int progress;
  final DateTime updatedAt;
  const DownloadRow({
    required this.podcastId,
    required this.episodeGuid,
    this.taskId,
    this.localPath,
    required this.status,
    required this.progress,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['podcast_id'] = Variable<int>(podcastId);
    map['episode_guid'] = Variable<String>(episodeGuid);
    if (!nullToAbsent || taskId != null) {
      map['task_id'] = Variable<String>(taskId);
    }
    if (!nullToAbsent || localPath != null) {
      map['local_path'] = Variable<String>(localPath);
    }
    map['status'] = Variable<String>(status);
    map['progress'] = Variable<int>(progress);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  DownloadsCompanion toCompanion(bool nullToAbsent) {
    return DownloadsCompanion(
      podcastId: Value(podcastId),
      episodeGuid: Value(episodeGuid),
      taskId: taskId == null && nullToAbsent
          ? const Value.absent()
          : Value(taskId),
      localPath: localPath == null && nullToAbsent
          ? const Value.absent()
          : Value(localPath),
      status: Value(status),
      progress: Value(progress),
      updatedAt: Value(updatedAt),
    );
  }

  factory DownloadRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DownloadRow(
      podcastId: serializer.fromJson<int>(json['podcastId']),
      episodeGuid: serializer.fromJson<String>(json['episodeGuid']),
      taskId: serializer.fromJson<String?>(json['taskId']),
      localPath: serializer.fromJson<String?>(json['localPath']),
      status: serializer.fromJson<String>(json['status']),
      progress: serializer.fromJson<int>(json['progress']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'podcastId': serializer.toJson<int>(podcastId),
      'episodeGuid': serializer.toJson<String>(episodeGuid),
      'taskId': serializer.toJson<String?>(taskId),
      'localPath': serializer.toJson<String?>(localPath),
      'status': serializer.toJson<String>(status),
      'progress': serializer.toJson<int>(progress),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  DownloadRow copyWith({
    int? podcastId,
    String? episodeGuid,
    Value<String?> taskId = const Value.absent(),
    Value<String?> localPath = const Value.absent(),
    String? status,
    int? progress,
    DateTime? updatedAt,
  }) => DownloadRow(
    podcastId: podcastId ?? this.podcastId,
    episodeGuid: episodeGuid ?? this.episodeGuid,
    taskId: taskId.present ? taskId.value : this.taskId,
    localPath: localPath.present ? localPath.value : this.localPath,
    status: status ?? this.status,
    progress: progress ?? this.progress,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  DownloadRow copyWithCompanion(DownloadsCompanion data) {
    return DownloadRow(
      podcastId: data.podcastId.present ? data.podcastId.value : this.podcastId,
      episodeGuid: data.episodeGuid.present
          ? data.episodeGuid.value
          : this.episodeGuid,
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
      localPath: data.localPath.present ? data.localPath.value : this.localPath,
      status: data.status.present ? data.status.value : this.status,
      progress: data.progress.present ? data.progress.value : this.progress,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DownloadRow(')
          ..write('podcastId: $podcastId, ')
          ..write('episodeGuid: $episodeGuid, ')
          ..write('taskId: $taskId, ')
          ..write('localPath: $localPath, ')
          ..write('status: $status, ')
          ..write('progress: $progress, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    podcastId,
    episodeGuid,
    taskId,
    localPath,
    status,
    progress,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DownloadRow &&
          other.podcastId == this.podcastId &&
          other.episodeGuid == this.episodeGuid &&
          other.taskId == this.taskId &&
          other.localPath == this.localPath &&
          other.status == this.status &&
          other.progress == this.progress &&
          other.updatedAt == this.updatedAt);
}

class DownloadsCompanion extends UpdateCompanion<DownloadRow> {
  final Value<int> podcastId;
  final Value<String> episodeGuid;
  final Value<String?> taskId;
  final Value<String?> localPath;
  final Value<String> status;
  final Value<int> progress;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const DownloadsCompanion({
    this.podcastId = const Value.absent(),
    this.episodeGuid = const Value.absent(),
    this.taskId = const Value.absent(),
    this.localPath = const Value.absent(),
    this.status = const Value.absent(),
    this.progress = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DownloadsCompanion.insert({
    required int podcastId,
    required String episodeGuid,
    this.taskId = const Value.absent(),
    this.localPath = const Value.absent(),
    this.status = const Value.absent(),
    this.progress = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : podcastId = Value(podcastId),
       episodeGuid = Value(episodeGuid);
  static Insertable<DownloadRow> custom({
    Expression<int>? podcastId,
    Expression<String>? episodeGuid,
    Expression<String>? taskId,
    Expression<String>? localPath,
    Expression<String>? status,
    Expression<int>? progress,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (podcastId != null) 'podcast_id': podcastId,
      if (episodeGuid != null) 'episode_guid': episodeGuid,
      if (taskId != null) 'task_id': taskId,
      if (localPath != null) 'local_path': localPath,
      if (status != null) 'status': status,
      if (progress != null) 'progress': progress,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DownloadsCompanion copyWith({
    Value<int>? podcastId,
    Value<String>? episodeGuid,
    Value<String?>? taskId,
    Value<String?>? localPath,
    Value<String>? status,
    Value<int>? progress,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return DownloadsCompanion(
      podcastId: podcastId ?? this.podcastId,
      episodeGuid: episodeGuid ?? this.episodeGuid,
      taskId: taskId ?? this.taskId,
      localPath: localPath ?? this.localPath,
      status: status ?? this.status,
      progress: progress ?? this.progress,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (podcastId.present) {
      map['podcast_id'] = Variable<int>(podcastId.value);
    }
    if (episodeGuid.present) {
      map['episode_guid'] = Variable<String>(episodeGuid.value);
    }
    if (taskId.present) {
      map['task_id'] = Variable<String>(taskId.value);
    }
    if (localPath.present) {
      map['local_path'] = Variable<String>(localPath.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (progress.present) {
      map['progress'] = Variable<int>(progress.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DownloadsCompanion(')
          ..write('podcastId: $podcastId, ')
          ..write('episodeGuid: $episodeGuid, ')
          ..write('taskId: $taskId, ')
          ..write('localPath: $localPath, ')
          ..write('status: $status, ')
          ..write('progress: $progress, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $QueueItemsTable extends QueueItems
    with TableInfo<$QueueItemsTable, QueueItemRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QueueItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _podcastIdMeta = const VerificationMeta(
    'podcastId',
  );
  @override
  late final GeneratedColumn<int> podcastId = GeneratedColumn<int>(
    'podcast_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _podcastTitleMeta = const VerificationMeta(
    'podcastTitle',
  );
  @override
  late final GeneratedColumn<String> podcastTitle = GeneratedColumn<String>(
    'podcast_title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _podcastAuthorMeta = const VerificationMeta(
    'podcastAuthor',
  );
  @override
  late final GeneratedColumn<String> podcastAuthor = GeneratedColumn<String>(
    'podcast_author',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _podcastFeedUrlMeta = const VerificationMeta(
    'podcastFeedUrl',
  );
  @override
  late final GeneratedColumn<String> podcastFeedUrl = GeneratedColumn<String>(
    'podcast_feed_url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _podcastArtworkUrlMeta = const VerificationMeta(
    'podcastArtworkUrl',
  );
  @override
  late final GeneratedColumn<String> podcastArtworkUrl =
      GeneratedColumn<String>(
        'podcast_artwork_url',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _episodeGuidMeta = const VerificationMeta(
    'episodeGuid',
  );
  @override
  late final GeneratedColumn<String> episodeGuid = GeneratedColumn<String>(
    'episode_guid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _episodeTitleMeta = const VerificationMeta(
    'episodeTitle',
  );
  @override
  late final GeneratedColumn<String> episodeTitle = GeneratedColumn<String>(
    'episode_title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _audioUrlMeta = const VerificationMeta(
    'audioUrl',
  );
  @override
  late final GeneratedColumn<String> audioUrl = GeneratedColumn<String>(
    'audio_url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _episodeImageUrlMeta = const VerificationMeta(
    'episodeImageUrl',
  );
  @override
  late final GeneratedColumn<String> episodeImageUrl = GeneratedColumn<String>(
    'episode_image_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _episodeDurationSecondsMeta =
      const VerificationMeta('episodeDurationSeconds');
  @override
  late final GeneratedColumn<int> episodeDurationSeconds = GeneratedColumn<int>(
    'episode_duration_seconds',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _episodePublishedAtMeta =
      const VerificationMeta('episodePublishedAt');
  @override
  late final GeneratedColumn<DateTime> episodePublishedAt =
      GeneratedColumn<DateTime>(
        'episode_published_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _addedAtMeta = const VerificationMeta(
    'addedAt',
  );
  @override
  late final GeneratedColumn<DateTime> addedAt = GeneratedColumn<DateTime>(
    'added_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    position,
    podcastId,
    podcastTitle,
    podcastAuthor,
    podcastFeedUrl,
    podcastArtworkUrl,
    episodeGuid,
    episodeTitle,
    audioUrl,
    episodeImageUrl,
    episodeDurationSeconds,
    episodePublishedAt,
    addedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'queue_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<QueueItemRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('podcast_id')) {
      context.handle(
        _podcastIdMeta,
        podcastId.isAcceptableOrUnknown(data['podcast_id']!, _podcastIdMeta),
      );
    } else if (isInserting) {
      context.missing(_podcastIdMeta);
    }
    if (data.containsKey('podcast_title')) {
      context.handle(
        _podcastTitleMeta,
        podcastTitle.isAcceptableOrUnknown(
          data['podcast_title']!,
          _podcastTitleMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_podcastTitleMeta);
    }
    if (data.containsKey('podcast_author')) {
      context.handle(
        _podcastAuthorMeta,
        podcastAuthor.isAcceptableOrUnknown(
          data['podcast_author']!,
          _podcastAuthorMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_podcastAuthorMeta);
    }
    if (data.containsKey('podcast_feed_url')) {
      context.handle(
        _podcastFeedUrlMeta,
        podcastFeedUrl.isAcceptableOrUnknown(
          data['podcast_feed_url']!,
          _podcastFeedUrlMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_podcastFeedUrlMeta);
    }
    if (data.containsKey('podcast_artwork_url')) {
      context.handle(
        _podcastArtworkUrlMeta,
        podcastArtworkUrl.isAcceptableOrUnknown(
          data['podcast_artwork_url']!,
          _podcastArtworkUrlMeta,
        ),
      );
    }
    if (data.containsKey('episode_guid')) {
      context.handle(
        _episodeGuidMeta,
        episodeGuid.isAcceptableOrUnknown(
          data['episode_guid']!,
          _episodeGuidMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_episodeGuidMeta);
    }
    if (data.containsKey('episode_title')) {
      context.handle(
        _episodeTitleMeta,
        episodeTitle.isAcceptableOrUnknown(
          data['episode_title']!,
          _episodeTitleMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_episodeTitleMeta);
    }
    if (data.containsKey('audio_url')) {
      context.handle(
        _audioUrlMeta,
        audioUrl.isAcceptableOrUnknown(data['audio_url']!, _audioUrlMeta),
      );
    } else if (isInserting) {
      context.missing(_audioUrlMeta);
    }
    if (data.containsKey('episode_image_url')) {
      context.handle(
        _episodeImageUrlMeta,
        episodeImageUrl.isAcceptableOrUnknown(
          data['episode_image_url']!,
          _episodeImageUrlMeta,
        ),
      );
    }
    if (data.containsKey('episode_duration_seconds')) {
      context.handle(
        _episodeDurationSecondsMeta,
        episodeDurationSeconds.isAcceptableOrUnknown(
          data['episode_duration_seconds']!,
          _episodeDurationSecondsMeta,
        ),
      );
    }
    if (data.containsKey('episode_published_at')) {
      context.handle(
        _episodePublishedAtMeta,
        episodePublishedAt.isAcceptableOrUnknown(
          data['episode_published_at']!,
          _episodePublishedAtMeta,
        ),
      );
    }
    if (data.containsKey('added_at')) {
      context.handle(
        _addedAtMeta,
        addedAt.isAcceptableOrUnknown(data['added_at']!, _addedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {podcastId, episodeGuid};
  @override
  QueueItemRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return QueueItemRow(
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      podcastId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}podcast_id'],
      )!,
      podcastTitle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}podcast_title'],
      )!,
      podcastAuthor: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}podcast_author'],
      )!,
      podcastFeedUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}podcast_feed_url'],
      )!,
      podcastArtworkUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}podcast_artwork_url'],
      ),
      episodeGuid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}episode_guid'],
      )!,
      episodeTitle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}episode_title'],
      )!,
      audioUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}audio_url'],
      )!,
      episodeImageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}episode_image_url'],
      ),
      episodeDurationSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}episode_duration_seconds'],
      ),
      episodePublishedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}episode_published_at'],
      ),
      addedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}added_at'],
      )!,
    );
  }

  @override
  $QueueItemsTable createAlias(String alias) {
    return $QueueItemsTable(attachedDatabase, alias);
  }
}

class QueueItemRow extends DataClass implements Insertable<QueueItemRow> {
  final int position;
  final int podcastId;
  final String podcastTitle;
  final String podcastAuthor;
  final String podcastFeedUrl;
  final String? podcastArtworkUrl;
  final String episodeGuid;
  final String episodeTitle;
  final String audioUrl;
  final String? episodeImageUrl;
  final int? episodeDurationSeconds;
  final DateTime? episodePublishedAt;
  final DateTime addedAt;
  const QueueItemRow({
    required this.position,
    required this.podcastId,
    required this.podcastTitle,
    required this.podcastAuthor,
    required this.podcastFeedUrl,
    this.podcastArtworkUrl,
    required this.episodeGuid,
    required this.episodeTitle,
    required this.audioUrl,
    this.episodeImageUrl,
    this.episodeDurationSeconds,
    this.episodePublishedAt,
    required this.addedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['position'] = Variable<int>(position);
    map['podcast_id'] = Variable<int>(podcastId);
    map['podcast_title'] = Variable<String>(podcastTitle);
    map['podcast_author'] = Variable<String>(podcastAuthor);
    map['podcast_feed_url'] = Variable<String>(podcastFeedUrl);
    if (!nullToAbsent || podcastArtworkUrl != null) {
      map['podcast_artwork_url'] = Variable<String>(podcastArtworkUrl);
    }
    map['episode_guid'] = Variable<String>(episodeGuid);
    map['episode_title'] = Variable<String>(episodeTitle);
    map['audio_url'] = Variable<String>(audioUrl);
    if (!nullToAbsent || episodeImageUrl != null) {
      map['episode_image_url'] = Variable<String>(episodeImageUrl);
    }
    if (!nullToAbsent || episodeDurationSeconds != null) {
      map['episode_duration_seconds'] = Variable<int>(episodeDurationSeconds);
    }
    if (!nullToAbsent || episodePublishedAt != null) {
      map['episode_published_at'] = Variable<DateTime>(episodePublishedAt);
    }
    map['added_at'] = Variable<DateTime>(addedAt);
    return map;
  }

  QueueItemsCompanion toCompanion(bool nullToAbsent) {
    return QueueItemsCompanion(
      position: Value(position),
      podcastId: Value(podcastId),
      podcastTitle: Value(podcastTitle),
      podcastAuthor: Value(podcastAuthor),
      podcastFeedUrl: Value(podcastFeedUrl),
      podcastArtworkUrl: podcastArtworkUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(podcastArtworkUrl),
      episodeGuid: Value(episodeGuid),
      episodeTitle: Value(episodeTitle),
      audioUrl: Value(audioUrl),
      episodeImageUrl: episodeImageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(episodeImageUrl),
      episodeDurationSeconds: episodeDurationSeconds == null && nullToAbsent
          ? const Value.absent()
          : Value(episodeDurationSeconds),
      episodePublishedAt: episodePublishedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(episodePublishedAt),
      addedAt: Value(addedAt),
    );
  }

  factory QueueItemRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return QueueItemRow(
      position: serializer.fromJson<int>(json['position']),
      podcastId: serializer.fromJson<int>(json['podcastId']),
      podcastTitle: serializer.fromJson<String>(json['podcastTitle']),
      podcastAuthor: serializer.fromJson<String>(json['podcastAuthor']),
      podcastFeedUrl: serializer.fromJson<String>(json['podcastFeedUrl']),
      podcastArtworkUrl: serializer.fromJson<String?>(
        json['podcastArtworkUrl'],
      ),
      episodeGuid: serializer.fromJson<String>(json['episodeGuid']),
      episodeTitle: serializer.fromJson<String>(json['episodeTitle']),
      audioUrl: serializer.fromJson<String>(json['audioUrl']),
      episodeImageUrl: serializer.fromJson<String?>(json['episodeImageUrl']),
      episodeDurationSeconds: serializer.fromJson<int?>(
        json['episodeDurationSeconds'],
      ),
      episodePublishedAt: serializer.fromJson<DateTime?>(
        json['episodePublishedAt'],
      ),
      addedAt: serializer.fromJson<DateTime>(json['addedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'position': serializer.toJson<int>(position),
      'podcastId': serializer.toJson<int>(podcastId),
      'podcastTitle': serializer.toJson<String>(podcastTitle),
      'podcastAuthor': serializer.toJson<String>(podcastAuthor),
      'podcastFeedUrl': serializer.toJson<String>(podcastFeedUrl),
      'podcastArtworkUrl': serializer.toJson<String?>(podcastArtworkUrl),
      'episodeGuid': serializer.toJson<String>(episodeGuid),
      'episodeTitle': serializer.toJson<String>(episodeTitle),
      'audioUrl': serializer.toJson<String>(audioUrl),
      'episodeImageUrl': serializer.toJson<String?>(episodeImageUrl),
      'episodeDurationSeconds': serializer.toJson<int?>(episodeDurationSeconds),
      'episodePublishedAt': serializer.toJson<DateTime?>(episodePublishedAt),
      'addedAt': serializer.toJson<DateTime>(addedAt),
    };
  }

  QueueItemRow copyWith({
    int? position,
    int? podcastId,
    String? podcastTitle,
    String? podcastAuthor,
    String? podcastFeedUrl,
    Value<String?> podcastArtworkUrl = const Value.absent(),
    String? episodeGuid,
    String? episodeTitle,
    String? audioUrl,
    Value<String?> episodeImageUrl = const Value.absent(),
    Value<int?> episodeDurationSeconds = const Value.absent(),
    Value<DateTime?> episodePublishedAt = const Value.absent(),
    DateTime? addedAt,
  }) => QueueItemRow(
    position: position ?? this.position,
    podcastId: podcastId ?? this.podcastId,
    podcastTitle: podcastTitle ?? this.podcastTitle,
    podcastAuthor: podcastAuthor ?? this.podcastAuthor,
    podcastFeedUrl: podcastFeedUrl ?? this.podcastFeedUrl,
    podcastArtworkUrl: podcastArtworkUrl.present
        ? podcastArtworkUrl.value
        : this.podcastArtworkUrl,
    episodeGuid: episodeGuid ?? this.episodeGuid,
    episodeTitle: episodeTitle ?? this.episodeTitle,
    audioUrl: audioUrl ?? this.audioUrl,
    episodeImageUrl: episodeImageUrl.present
        ? episodeImageUrl.value
        : this.episodeImageUrl,
    episodeDurationSeconds: episodeDurationSeconds.present
        ? episodeDurationSeconds.value
        : this.episodeDurationSeconds,
    episodePublishedAt: episodePublishedAt.present
        ? episodePublishedAt.value
        : this.episodePublishedAt,
    addedAt: addedAt ?? this.addedAt,
  );
  QueueItemRow copyWithCompanion(QueueItemsCompanion data) {
    return QueueItemRow(
      position: data.position.present ? data.position.value : this.position,
      podcastId: data.podcastId.present ? data.podcastId.value : this.podcastId,
      podcastTitle: data.podcastTitle.present
          ? data.podcastTitle.value
          : this.podcastTitle,
      podcastAuthor: data.podcastAuthor.present
          ? data.podcastAuthor.value
          : this.podcastAuthor,
      podcastFeedUrl: data.podcastFeedUrl.present
          ? data.podcastFeedUrl.value
          : this.podcastFeedUrl,
      podcastArtworkUrl: data.podcastArtworkUrl.present
          ? data.podcastArtworkUrl.value
          : this.podcastArtworkUrl,
      episodeGuid: data.episodeGuid.present
          ? data.episodeGuid.value
          : this.episodeGuid,
      episodeTitle: data.episodeTitle.present
          ? data.episodeTitle.value
          : this.episodeTitle,
      audioUrl: data.audioUrl.present ? data.audioUrl.value : this.audioUrl,
      episodeImageUrl: data.episodeImageUrl.present
          ? data.episodeImageUrl.value
          : this.episodeImageUrl,
      episodeDurationSeconds: data.episodeDurationSeconds.present
          ? data.episodeDurationSeconds.value
          : this.episodeDurationSeconds,
      episodePublishedAt: data.episodePublishedAt.present
          ? data.episodePublishedAt.value
          : this.episodePublishedAt,
      addedAt: data.addedAt.present ? data.addedAt.value : this.addedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('QueueItemRow(')
          ..write('position: $position, ')
          ..write('podcastId: $podcastId, ')
          ..write('podcastTitle: $podcastTitle, ')
          ..write('podcastAuthor: $podcastAuthor, ')
          ..write('podcastFeedUrl: $podcastFeedUrl, ')
          ..write('podcastArtworkUrl: $podcastArtworkUrl, ')
          ..write('episodeGuid: $episodeGuid, ')
          ..write('episodeTitle: $episodeTitle, ')
          ..write('audioUrl: $audioUrl, ')
          ..write('episodeImageUrl: $episodeImageUrl, ')
          ..write('episodeDurationSeconds: $episodeDurationSeconds, ')
          ..write('episodePublishedAt: $episodePublishedAt, ')
          ..write('addedAt: $addedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    position,
    podcastId,
    podcastTitle,
    podcastAuthor,
    podcastFeedUrl,
    podcastArtworkUrl,
    episodeGuid,
    episodeTitle,
    audioUrl,
    episodeImageUrl,
    episodeDurationSeconds,
    episodePublishedAt,
    addedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is QueueItemRow &&
          other.position == this.position &&
          other.podcastId == this.podcastId &&
          other.podcastTitle == this.podcastTitle &&
          other.podcastAuthor == this.podcastAuthor &&
          other.podcastFeedUrl == this.podcastFeedUrl &&
          other.podcastArtworkUrl == this.podcastArtworkUrl &&
          other.episodeGuid == this.episodeGuid &&
          other.episodeTitle == this.episodeTitle &&
          other.audioUrl == this.audioUrl &&
          other.episodeImageUrl == this.episodeImageUrl &&
          other.episodeDurationSeconds == this.episodeDurationSeconds &&
          other.episodePublishedAt == this.episodePublishedAt &&
          other.addedAt == this.addedAt);
}

class QueueItemsCompanion extends UpdateCompanion<QueueItemRow> {
  final Value<int> position;
  final Value<int> podcastId;
  final Value<String> podcastTitle;
  final Value<String> podcastAuthor;
  final Value<String> podcastFeedUrl;
  final Value<String?> podcastArtworkUrl;
  final Value<String> episodeGuid;
  final Value<String> episodeTitle;
  final Value<String> audioUrl;
  final Value<String?> episodeImageUrl;
  final Value<int?> episodeDurationSeconds;
  final Value<DateTime?> episodePublishedAt;
  final Value<DateTime> addedAt;
  final Value<int> rowid;
  const QueueItemsCompanion({
    this.position = const Value.absent(),
    this.podcastId = const Value.absent(),
    this.podcastTitle = const Value.absent(),
    this.podcastAuthor = const Value.absent(),
    this.podcastFeedUrl = const Value.absent(),
    this.podcastArtworkUrl = const Value.absent(),
    this.episodeGuid = const Value.absent(),
    this.episodeTitle = const Value.absent(),
    this.audioUrl = const Value.absent(),
    this.episodeImageUrl = const Value.absent(),
    this.episodeDurationSeconds = const Value.absent(),
    this.episodePublishedAt = const Value.absent(),
    this.addedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  QueueItemsCompanion.insert({
    required int position,
    required int podcastId,
    required String podcastTitle,
    required String podcastAuthor,
    required String podcastFeedUrl,
    this.podcastArtworkUrl = const Value.absent(),
    required String episodeGuid,
    required String episodeTitle,
    required String audioUrl,
    this.episodeImageUrl = const Value.absent(),
    this.episodeDurationSeconds = const Value.absent(),
    this.episodePublishedAt = const Value.absent(),
    this.addedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : position = Value(position),
       podcastId = Value(podcastId),
       podcastTitle = Value(podcastTitle),
       podcastAuthor = Value(podcastAuthor),
       podcastFeedUrl = Value(podcastFeedUrl),
       episodeGuid = Value(episodeGuid),
       episodeTitle = Value(episodeTitle),
       audioUrl = Value(audioUrl);
  static Insertable<QueueItemRow> custom({
    Expression<int>? position,
    Expression<int>? podcastId,
    Expression<String>? podcastTitle,
    Expression<String>? podcastAuthor,
    Expression<String>? podcastFeedUrl,
    Expression<String>? podcastArtworkUrl,
    Expression<String>? episodeGuid,
    Expression<String>? episodeTitle,
    Expression<String>? audioUrl,
    Expression<String>? episodeImageUrl,
    Expression<int>? episodeDurationSeconds,
    Expression<DateTime>? episodePublishedAt,
    Expression<DateTime>? addedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (position != null) 'position': position,
      if (podcastId != null) 'podcast_id': podcastId,
      if (podcastTitle != null) 'podcast_title': podcastTitle,
      if (podcastAuthor != null) 'podcast_author': podcastAuthor,
      if (podcastFeedUrl != null) 'podcast_feed_url': podcastFeedUrl,
      if (podcastArtworkUrl != null) 'podcast_artwork_url': podcastArtworkUrl,
      if (episodeGuid != null) 'episode_guid': episodeGuid,
      if (episodeTitle != null) 'episode_title': episodeTitle,
      if (audioUrl != null) 'audio_url': audioUrl,
      if (episodeImageUrl != null) 'episode_image_url': episodeImageUrl,
      if (episodeDurationSeconds != null)
        'episode_duration_seconds': episodeDurationSeconds,
      if (episodePublishedAt != null)
        'episode_published_at': episodePublishedAt,
      if (addedAt != null) 'added_at': addedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  QueueItemsCompanion copyWith({
    Value<int>? position,
    Value<int>? podcastId,
    Value<String>? podcastTitle,
    Value<String>? podcastAuthor,
    Value<String>? podcastFeedUrl,
    Value<String?>? podcastArtworkUrl,
    Value<String>? episodeGuid,
    Value<String>? episodeTitle,
    Value<String>? audioUrl,
    Value<String?>? episodeImageUrl,
    Value<int?>? episodeDurationSeconds,
    Value<DateTime?>? episodePublishedAt,
    Value<DateTime>? addedAt,
    Value<int>? rowid,
  }) {
    return QueueItemsCompanion(
      position: position ?? this.position,
      podcastId: podcastId ?? this.podcastId,
      podcastTitle: podcastTitle ?? this.podcastTitle,
      podcastAuthor: podcastAuthor ?? this.podcastAuthor,
      podcastFeedUrl: podcastFeedUrl ?? this.podcastFeedUrl,
      podcastArtworkUrl: podcastArtworkUrl ?? this.podcastArtworkUrl,
      episodeGuid: episodeGuid ?? this.episodeGuid,
      episodeTitle: episodeTitle ?? this.episodeTitle,
      audioUrl: audioUrl ?? this.audioUrl,
      episodeImageUrl: episodeImageUrl ?? this.episodeImageUrl,
      episodeDurationSeconds:
          episodeDurationSeconds ?? this.episodeDurationSeconds,
      episodePublishedAt: episodePublishedAt ?? this.episodePublishedAt,
      addedAt: addedAt ?? this.addedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (podcastId.present) {
      map['podcast_id'] = Variable<int>(podcastId.value);
    }
    if (podcastTitle.present) {
      map['podcast_title'] = Variable<String>(podcastTitle.value);
    }
    if (podcastAuthor.present) {
      map['podcast_author'] = Variable<String>(podcastAuthor.value);
    }
    if (podcastFeedUrl.present) {
      map['podcast_feed_url'] = Variable<String>(podcastFeedUrl.value);
    }
    if (podcastArtworkUrl.present) {
      map['podcast_artwork_url'] = Variable<String>(podcastArtworkUrl.value);
    }
    if (episodeGuid.present) {
      map['episode_guid'] = Variable<String>(episodeGuid.value);
    }
    if (episodeTitle.present) {
      map['episode_title'] = Variable<String>(episodeTitle.value);
    }
    if (audioUrl.present) {
      map['audio_url'] = Variable<String>(audioUrl.value);
    }
    if (episodeImageUrl.present) {
      map['episode_image_url'] = Variable<String>(episodeImageUrl.value);
    }
    if (episodeDurationSeconds.present) {
      map['episode_duration_seconds'] = Variable<int>(
        episodeDurationSeconds.value,
      );
    }
    if (episodePublishedAt.present) {
      map['episode_published_at'] = Variable<DateTime>(
        episodePublishedAt.value,
      );
    }
    if (addedAt.present) {
      map['added_at'] = Variable<DateTime>(addedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QueueItemsCompanion(')
          ..write('position: $position, ')
          ..write('podcastId: $podcastId, ')
          ..write('podcastTitle: $podcastTitle, ')
          ..write('podcastAuthor: $podcastAuthor, ')
          ..write('podcastFeedUrl: $podcastFeedUrl, ')
          ..write('podcastArtworkUrl: $podcastArtworkUrl, ')
          ..write('episodeGuid: $episodeGuid, ')
          ..write('episodeTitle: $episodeTitle, ')
          ..write('audioUrl: $audioUrl, ')
          ..write('episodeImageUrl: $episodeImageUrl, ')
          ..write('episodeDurationSeconds: $episodeDurationSeconds, ')
          ..write('episodePublishedAt: $episodePublishedAt, ')
          ..write('addedAt: $addedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ChaptersTable extends Chapters
    with TableInfo<$ChaptersTable, ChapterRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChaptersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _podcastIdMeta = const VerificationMeta(
    'podcastId',
  );
  @override
  late final GeneratedColumn<int> podcastId = GeneratedColumn<int>(
    'podcast_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _episodeGuidMeta = const VerificationMeta(
    'episodeGuid',
  );
  @override
  late final GeneratedColumn<String> episodeGuid = GeneratedColumn<String>(
    'episode_guid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startMsMeta = const VerificationMeta(
    'startMs',
  );
  @override
  late final GeneratedColumn<int> startMs = GeneratedColumn<int>(
    'start_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _imageUrlMeta = const VerificationMeta(
    'imageUrl',
  );
  @override
  late final GeneratedColumn<String> imageUrl = GeneratedColumn<String>(
    'image_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    podcastId,
    episodeGuid,
    startMs,
    title,
    imageUrl,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chapters';
  @override
  VerificationContext validateIntegrity(
    Insertable<ChapterRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('podcast_id')) {
      context.handle(
        _podcastIdMeta,
        podcastId.isAcceptableOrUnknown(data['podcast_id']!, _podcastIdMeta),
      );
    } else if (isInserting) {
      context.missing(_podcastIdMeta);
    }
    if (data.containsKey('episode_guid')) {
      context.handle(
        _episodeGuidMeta,
        episodeGuid.isAcceptableOrUnknown(
          data['episode_guid']!,
          _episodeGuidMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_episodeGuidMeta);
    }
    if (data.containsKey('start_ms')) {
      context.handle(
        _startMsMeta,
        startMs.isAcceptableOrUnknown(data['start_ms']!, _startMsMeta),
      );
    } else if (isInserting) {
      context.missing(_startMsMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('image_url')) {
      context.handle(
        _imageUrlMeta,
        imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {podcastId, episodeGuid, startMs};
  @override
  ChapterRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChapterRow(
      podcastId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}podcast_id'],
      )!,
      episodeGuid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}episode_guid'],
      )!,
      startMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}start_ms'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      imageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_url'],
      ),
    );
  }

  @override
  $ChaptersTable createAlias(String alias) {
    return $ChaptersTable(attachedDatabase, alias);
  }
}

class ChapterRow extends DataClass implements Insertable<ChapterRow> {
  final int podcastId;
  final String episodeGuid;

  /// Início do capítulo em milissegundos (o JSON traz segundos fracionários).
  final int startMs;
  final String title;
  final String? imageUrl;
  const ChapterRow({
    required this.podcastId,
    required this.episodeGuid,
    required this.startMs,
    required this.title,
    this.imageUrl,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['podcast_id'] = Variable<int>(podcastId);
    map['episode_guid'] = Variable<String>(episodeGuid);
    map['start_ms'] = Variable<int>(startMs);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || imageUrl != null) {
      map['image_url'] = Variable<String>(imageUrl);
    }
    return map;
  }

  ChaptersCompanion toCompanion(bool nullToAbsent) {
    return ChaptersCompanion(
      podcastId: Value(podcastId),
      episodeGuid: Value(episodeGuid),
      startMs: Value(startMs),
      title: Value(title),
      imageUrl: imageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(imageUrl),
    );
  }

  factory ChapterRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChapterRow(
      podcastId: serializer.fromJson<int>(json['podcastId']),
      episodeGuid: serializer.fromJson<String>(json['episodeGuid']),
      startMs: serializer.fromJson<int>(json['startMs']),
      title: serializer.fromJson<String>(json['title']),
      imageUrl: serializer.fromJson<String?>(json['imageUrl']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'podcastId': serializer.toJson<int>(podcastId),
      'episodeGuid': serializer.toJson<String>(episodeGuid),
      'startMs': serializer.toJson<int>(startMs),
      'title': serializer.toJson<String>(title),
      'imageUrl': serializer.toJson<String?>(imageUrl),
    };
  }

  ChapterRow copyWith({
    int? podcastId,
    String? episodeGuid,
    int? startMs,
    String? title,
    Value<String?> imageUrl = const Value.absent(),
  }) => ChapterRow(
    podcastId: podcastId ?? this.podcastId,
    episodeGuid: episodeGuid ?? this.episodeGuid,
    startMs: startMs ?? this.startMs,
    title: title ?? this.title,
    imageUrl: imageUrl.present ? imageUrl.value : this.imageUrl,
  );
  ChapterRow copyWithCompanion(ChaptersCompanion data) {
    return ChapterRow(
      podcastId: data.podcastId.present ? data.podcastId.value : this.podcastId,
      episodeGuid: data.episodeGuid.present
          ? data.episodeGuid.value
          : this.episodeGuid,
      startMs: data.startMs.present ? data.startMs.value : this.startMs,
      title: data.title.present ? data.title.value : this.title,
      imageUrl: data.imageUrl.present ? data.imageUrl.value : this.imageUrl,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChapterRow(')
          ..write('podcastId: $podcastId, ')
          ..write('episodeGuid: $episodeGuid, ')
          ..write('startMs: $startMs, ')
          ..write('title: $title, ')
          ..write('imageUrl: $imageUrl')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(podcastId, episodeGuid, startMs, title, imageUrl);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChapterRow &&
          other.podcastId == this.podcastId &&
          other.episodeGuid == this.episodeGuid &&
          other.startMs == this.startMs &&
          other.title == this.title &&
          other.imageUrl == this.imageUrl);
}

class ChaptersCompanion extends UpdateCompanion<ChapterRow> {
  final Value<int> podcastId;
  final Value<String> episodeGuid;
  final Value<int> startMs;
  final Value<String> title;
  final Value<String?> imageUrl;
  final Value<int> rowid;
  const ChaptersCompanion({
    this.podcastId = const Value.absent(),
    this.episodeGuid = const Value.absent(),
    this.startMs = const Value.absent(),
    this.title = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChaptersCompanion.insert({
    required int podcastId,
    required String episodeGuid,
    required int startMs,
    required String title,
    this.imageUrl = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : podcastId = Value(podcastId),
       episodeGuid = Value(episodeGuid),
       startMs = Value(startMs),
       title = Value(title);
  static Insertable<ChapterRow> custom({
    Expression<int>? podcastId,
    Expression<String>? episodeGuid,
    Expression<int>? startMs,
    Expression<String>? title,
    Expression<String>? imageUrl,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (podcastId != null) 'podcast_id': podcastId,
      if (episodeGuid != null) 'episode_guid': episodeGuid,
      if (startMs != null) 'start_ms': startMs,
      if (title != null) 'title': title,
      if (imageUrl != null) 'image_url': imageUrl,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChaptersCompanion copyWith({
    Value<int>? podcastId,
    Value<String>? episodeGuid,
    Value<int>? startMs,
    Value<String>? title,
    Value<String?>? imageUrl,
    Value<int>? rowid,
  }) {
    return ChaptersCompanion(
      podcastId: podcastId ?? this.podcastId,
      episodeGuid: episodeGuid ?? this.episodeGuid,
      startMs: startMs ?? this.startMs,
      title: title ?? this.title,
      imageUrl: imageUrl ?? this.imageUrl,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (podcastId.present) {
      map['podcast_id'] = Variable<int>(podcastId.value);
    }
    if (episodeGuid.present) {
      map['episode_guid'] = Variable<String>(episodeGuid.value);
    }
    if (startMs.present) {
      map['start_ms'] = Variable<int>(startMs.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChaptersCompanion(')
          ..write('podcastId: $podcastId, ')
          ..write('episodeGuid: $episodeGuid, ')
          ..write('startMs: $startMs, ')
          ..write('title: $title, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ListenHistoryTable extends ListenHistory
    with TableInfo<$ListenHistoryTable, ListenHistoryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ListenHistoryTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _podcastIdMeta = const VerificationMeta(
    'podcastId',
  );
  @override
  late final GeneratedColumn<int> podcastId = GeneratedColumn<int>(
    'podcast_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _episodeGuidMeta = const VerificationMeta(
    'episodeGuid',
  );
  @override
  late final GeneratedColumn<String> episodeGuid = GeneratedColumn<String>(
    'episode_guid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dayMeta = const VerificationMeta('day');
  @override
  late final GeneratedColumn<DateTime> day = GeneratedColumn<DateTime>(
    'day',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _secondsListenedMeta = const VerificationMeta(
    'secondsListened',
  );
  @override
  late final GeneratedColumn<int> secondsListened = GeneratedColumn<int>(
    'seconds_listened',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    podcastId,
    episodeGuid,
    day,
    secondsListened,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'listen_history';
  @override
  VerificationContext validateIntegrity(
    Insertable<ListenHistoryRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('podcast_id')) {
      context.handle(
        _podcastIdMeta,
        podcastId.isAcceptableOrUnknown(data['podcast_id']!, _podcastIdMeta),
      );
    } else if (isInserting) {
      context.missing(_podcastIdMeta);
    }
    if (data.containsKey('episode_guid')) {
      context.handle(
        _episodeGuidMeta,
        episodeGuid.isAcceptableOrUnknown(
          data['episode_guid']!,
          _episodeGuidMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_episodeGuidMeta);
    }
    if (data.containsKey('day')) {
      context.handle(
        _dayMeta,
        day.isAcceptableOrUnknown(data['day']!, _dayMeta),
      );
    } else if (isInserting) {
      context.missing(_dayMeta);
    }
    if (data.containsKey('seconds_listened')) {
      context.handle(
        _secondsListenedMeta,
        secondsListened.isAcceptableOrUnknown(
          data['seconds_listened']!,
          _secondsListenedMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {podcastId, episodeGuid, day};
  @override
  ListenHistoryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ListenHistoryRow(
      podcastId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}podcast_id'],
      )!,
      episodeGuid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}episode_guid'],
      )!,
      day: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}day'],
      )!,
      secondsListened: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}seconds_listened'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ListenHistoryTable createAlias(String alias) {
    return $ListenHistoryTable(attachedDatabase, alias);
  }
}

class ListenHistoryRow extends DataClass
    implements Insertable<ListenHistoryRow> {
  final int podcastId;
  final String episodeGuid;

  /// Meia-noite local do dia em que ouviu — agrupa por dia pra streak/semana.
  final DateTime day;
  final int secondsListened;
  final DateTime updatedAt;
  const ListenHistoryRow({
    required this.podcastId,
    required this.episodeGuid,
    required this.day,
    required this.secondsListened,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['podcast_id'] = Variable<int>(podcastId);
    map['episode_guid'] = Variable<String>(episodeGuid);
    map['day'] = Variable<DateTime>(day);
    map['seconds_listened'] = Variable<int>(secondsListened);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ListenHistoryCompanion toCompanion(bool nullToAbsent) {
    return ListenHistoryCompanion(
      podcastId: Value(podcastId),
      episodeGuid: Value(episodeGuid),
      day: Value(day),
      secondsListened: Value(secondsListened),
      updatedAt: Value(updatedAt),
    );
  }

  factory ListenHistoryRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ListenHistoryRow(
      podcastId: serializer.fromJson<int>(json['podcastId']),
      episodeGuid: serializer.fromJson<String>(json['episodeGuid']),
      day: serializer.fromJson<DateTime>(json['day']),
      secondsListened: serializer.fromJson<int>(json['secondsListened']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'podcastId': serializer.toJson<int>(podcastId),
      'episodeGuid': serializer.toJson<String>(episodeGuid),
      'day': serializer.toJson<DateTime>(day),
      'secondsListened': serializer.toJson<int>(secondsListened),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ListenHistoryRow copyWith({
    int? podcastId,
    String? episodeGuid,
    DateTime? day,
    int? secondsListened,
    DateTime? updatedAt,
  }) => ListenHistoryRow(
    podcastId: podcastId ?? this.podcastId,
    episodeGuid: episodeGuid ?? this.episodeGuid,
    day: day ?? this.day,
    secondsListened: secondsListened ?? this.secondsListened,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ListenHistoryRow copyWithCompanion(ListenHistoryCompanion data) {
    return ListenHistoryRow(
      podcastId: data.podcastId.present ? data.podcastId.value : this.podcastId,
      episodeGuid: data.episodeGuid.present
          ? data.episodeGuid.value
          : this.episodeGuid,
      day: data.day.present ? data.day.value : this.day,
      secondsListened: data.secondsListened.present
          ? data.secondsListened.value
          : this.secondsListened,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ListenHistoryRow(')
          ..write('podcastId: $podcastId, ')
          ..write('episodeGuid: $episodeGuid, ')
          ..write('day: $day, ')
          ..write('secondsListened: $secondsListened, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(podcastId, episodeGuid, day, secondsListened, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ListenHistoryRow &&
          other.podcastId == this.podcastId &&
          other.episodeGuid == this.episodeGuid &&
          other.day == this.day &&
          other.secondsListened == this.secondsListened &&
          other.updatedAt == this.updatedAt);
}

class ListenHistoryCompanion extends UpdateCompanion<ListenHistoryRow> {
  final Value<int> podcastId;
  final Value<String> episodeGuid;
  final Value<DateTime> day;
  final Value<int> secondsListened;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const ListenHistoryCompanion({
    this.podcastId = const Value.absent(),
    this.episodeGuid = const Value.absent(),
    this.day = const Value.absent(),
    this.secondsListened = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ListenHistoryCompanion.insert({
    required int podcastId,
    required String episodeGuid,
    required DateTime day,
    this.secondsListened = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : podcastId = Value(podcastId),
       episodeGuid = Value(episodeGuid),
       day = Value(day);
  static Insertable<ListenHistoryRow> custom({
    Expression<int>? podcastId,
    Expression<String>? episodeGuid,
    Expression<DateTime>? day,
    Expression<int>? secondsListened,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (podcastId != null) 'podcast_id': podcastId,
      if (episodeGuid != null) 'episode_guid': episodeGuid,
      if (day != null) 'day': day,
      if (secondsListened != null) 'seconds_listened': secondsListened,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ListenHistoryCompanion copyWith({
    Value<int>? podcastId,
    Value<String>? episodeGuid,
    Value<DateTime>? day,
    Value<int>? secondsListened,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return ListenHistoryCompanion(
      podcastId: podcastId ?? this.podcastId,
      episodeGuid: episodeGuid ?? this.episodeGuid,
      day: day ?? this.day,
      secondsListened: secondsListened ?? this.secondsListened,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (podcastId.present) {
      map['podcast_id'] = Variable<int>(podcastId.value);
    }
    if (episodeGuid.present) {
      map['episode_guid'] = Variable<String>(episodeGuid.value);
    }
    if (day.present) {
      map['day'] = Variable<DateTime>(day.value);
    }
    if (secondsListened.present) {
      map['seconds_listened'] = Variable<int>(secondsListened.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ListenHistoryCompanion(')
          ..write('podcastId: $podcastId, ')
          ..write('episodeGuid: $episodeGuid, ')
          ..write('day: $day, ')
          ..write('secondsListened: $secondsListened, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SubscriptionsTable subscriptions = $SubscriptionsTable(this);
  late final $EpisodeCacheTable episodeCache = $EpisodeCacheTable(this);
  late final $PlaybackProgressTable playbackProgress = $PlaybackProgressTable(
    this,
  );
  late final $DownloadsTable downloads = $DownloadsTable(this);
  late final $QueueItemsTable queueItems = $QueueItemsTable(this);
  late final $ChaptersTable chapters = $ChaptersTable(this);
  late final $ListenHistoryTable listenHistory = $ListenHistoryTable(this);
  late final Index idxEpisodeCacheRecent = Index(
    'idx_episode_cache_recent',
    'CREATE INDEX idx_episode_cache_recent ON episode_cache (archived, published_at)',
  );
  late final Index idxPlaybackProgressContinue = Index(
    'idx_playback_progress_continue',
    'CREATE INDEX idx_playback_progress_continue ON playback_progress (completed, updated_at)',
  );
  late final Index idxDownloadsTaskId = Index(
    'idx_downloads_task_id',
    'CREATE INDEX idx_downloads_task_id ON downloads (task_id)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    subscriptions,
    episodeCache,
    playbackProgress,
    downloads,
    queueItems,
    chapters,
    listenHistory,
    idxEpisodeCacheRecent,
    idxPlaybackProgressContinue,
    idxDownloadsTaskId,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'subscriptions',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('episode_cache', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'subscriptions',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('playback_progress', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'subscriptions',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('downloads', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$SubscriptionsTableCreateCompanionBuilder =
    SubscriptionsCompanion Function({
      Value<int> id,
      required String title,
      required String author,
      required String feedUrl,
      Value<String?> artworkUrl,
      Value<String?> genre,
      Value<int> episodeCount,
      Value<DateTime> subscribedAt,
      Value<DateTime?> lastRefreshedAt,
      Value<String> autoDownload,
      Value<int> autoDownloadLimit,
      Value<int> autoDeletePlayedDays,
      Value<double?> playbackSpeedOverride,
    });
typedef $$SubscriptionsTableUpdateCompanionBuilder =
    SubscriptionsCompanion Function({
      Value<int> id,
      Value<String> title,
      Value<String> author,
      Value<String> feedUrl,
      Value<String?> artworkUrl,
      Value<String?> genre,
      Value<int> episodeCount,
      Value<DateTime> subscribedAt,
      Value<DateTime?> lastRefreshedAt,
      Value<String> autoDownload,
      Value<int> autoDownloadLimit,
      Value<int> autoDeletePlayedDays,
      Value<double?> playbackSpeedOverride,
    });

final class $$SubscriptionsTableReferences
    extends
        BaseReferences<_$AppDatabase, $SubscriptionsTable, SubscriptionRow> {
  $$SubscriptionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$EpisodeCacheTable, List<EpisodeCacheRow>>
  _episodeCacheRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.episodeCache,
    aliasName: 'subscriptions__id__episode_cache__podcast_id',
  );

  $$EpisodeCacheTableProcessedTableManager get episodeCacheRefs {
    final manager = $$EpisodeCacheTableTableManager(
      $_db,
      $_db.episodeCache,
    ).filter((f) => f.podcastId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_episodeCacheRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PlaybackProgressTable, List<PlaybackProgressRow>>
  _playbackProgressRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.playbackProgress,
    aliasName: 'subscriptions__id__playback_progress__podcast_id',
  );

  $$PlaybackProgressTableProcessedTableManager get playbackProgressRefs {
    final manager = $$PlaybackProgressTableTableManager(
      $_db,
      $_db.playbackProgress,
    ).filter((f) => f.podcastId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _playbackProgressRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$DownloadsTable, List<DownloadRow>>
  _downloadsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.downloads,
    aliasName: 'subscriptions__id__downloads__podcast_id',
  );

  $$DownloadsTableProcessedTableManager get downloadsRefs {
    final manager = $$DownloadsTableTableManager(
      $_db,
      $_db.downloads,
    ).filter((f) => f.podcastId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_downloadsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SubscriptionsTableFilterComposer
    extends Composer<_$AppDatabase, $SubscriptionsTable> {
  $$SubscriptionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get author => $composableBuilder(
    column: $table.author,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get feedUrl => $composableBuilder(
    column: $table.feedUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get artworkUrl => $composableBuilder(
    column: $table.artworkUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get genre => $composableBuilder(
    column: $table.genre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get episodeCount => $composableBuilder(
    column: $table.episodeCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get subscribedAt => $composableBuilder(
    column: $table.subscribedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastRefreshedAt => $composableBuilder(
    column: $table.lastRefreshedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get autoDownload => $composableBuilder(
    column: $table.autoDownload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get autoDownloadLimit => $composableBuilder(
    column: $table.autoDownloadLimit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get autoDeletePlayedDays => $composableBuilder(
    column: $table.autoDeletePlayedDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get playbackSpeedOverride => $composableBuilder(
    column: $table.playbackSpeedOverride,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> episodeCacheRefs(
    Expression<bool> Function($$EpisodeCacheTableFilterComposer f) f,
  ) {
    final $$EpisodeCacheTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.episodeCache,
      getReferencedColumn: (t) => t.podcastId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EpisodeCacheTableFilterComposer(
            $db: $db,
            $table: $db.episodeCache,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> playbackProgressRefs(
    Expression<bool> Function($$PlaybackProgressTableFilterComposer f) f,
  ) {
    final $$PlaybackProgressTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.playbackProgress,
      getReferencedColumn: (t) => t.podcastId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlaybackProgressTableFilterComposer(
            $db: $db,
            $table: $db.playbackProgress,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> downloadsRefs(
    Expression<bool> Function($$DownloadsTableFilterComposer f) f,
  ) {
    final $$DownloadsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.downloads,
      getReferencedColumn: (t) => t.podcastId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DownloadsTableFilterComposer(
            $db: $db,
            $table: $db.downloads,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SubscriptionsTableOrderingComposer
    extends Composer<_$AppDatabase, $SubscriptionsTable> {
  $$SubscriptionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get author => $composableBuilder(
    column: $table.author,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get feedUrl => $composableBuilder(
    column: $table.feedUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get artworkUrl => $composableBuilder(
    column: $table.artworkUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get genre => $composableBuilder(
    column: $table.genre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get episodeCount => $composableBuilder(
    column: $table.episodeCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get subscribedAt => $composableBuilder(
    column: $table.subscribedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastRefreshedAt => $composableBuilder(
    column: $table.lastRefreshedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get autoDownload => $composableBuilder(
    column: $table.autoDownload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get autoDownloadLimit => $composableBuilder(
    column: $table.autoDownloadLimit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get autoDeletePlayedDays => $composableBuilder(
    column: $table.autoDeletePlayedDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get playbackSpeedOverride => $composableBuilder(
    column: $table.playbackSpeedOverride,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SubscriptionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SubscriptionsTable> {
  $$SubscriptionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get author =>
      $composableBuilder(column: $table.author, builder: (column) => column);

  GeneratedColumn<String> get feedUrl =>
      $composableBuilder(column: $table.feedUrl, builder: (column) => column);

  GeneratedColumn<String> get artworkUrl => $composableBuilder(
    column: $table.artworkUrl,
    builder: (column) => column,
  );

  GeneratedColumn<String> get genre =>
      $composableBuilder(column: $table.genre, builder: (column) => column);

  GeneratedColumn<int> get episodeCount => $composableBuilder(
    column: $table.episodeCount,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get subscribedAt => $composableBuilder(
    column: $table.subscribedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastRefreshedAt => $composableBuilder(
    column: $table.lastRefreshedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get autoDownload => $composableBuilder(
    column: $table.autoDownload,
    builder: (column) => column,
  );

  GeneratedColumn<int> get autoDownloadLimit => $composableBuilder(
    column: $table.autoDownloadLimit,
    builder: (column) => column,
  );

  GeneratedColumn<int> get autoDeletePlayedDays => $composableBuilder(
    column: $table.autoDeletePlayedDays,
    builder: (column) => column,
  );

  GeneratedColumn<double> get playbackSpeedOverride => $composableBuilder(
    column: $table.playbackSpeedOverride,
    builder: (column) => column,
  );

  Expression<T> episodeCacheRefs<T extends Object>(
    Expression<T> Function($$EpisodeCacheTableAnnotationComposer a) f,
  ) {
    final $$EpisodeCacheTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.episodeCache,
      getReferencedColumn: (t) => t.podcastId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EpisodeCacheTableAnnotationComposer(
            $db: $db,
            $table: $db.episodeCache,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> playbackProgressRefs<T extends Object>(
    Expression<T> Function($$PlaybackProgressTableAnnotationComposer a) f,
  ) {
    final $$PlaybackProgressTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.playbackProgress,
      getReferencedColumn: (t) => t.podcastId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlaybackProgressTableAnnotationComposer(
            $db: $db,
            $table: $db.playbackProgress,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> downloadsRefs<T extends Object>(
    Expression<T> Function($$DownloadsTableAnnotationComposer a) f,
  ) {
    final $$DownloadsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.downloads,
      getReferencedColumn: (t) => t.podcastId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DownloadsTableAnnotationComposer(
            $db: $db,
            $table: $db.downloads,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SubscriptionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SubscriptionsTable,
          SubscriptionRow,
          $$SubscriptionsTableFilterComposer,
          $$SubscriptionsTableOrderingComposer,
          $$SubscriptionsTableAnnotationComposer,
          $$SubscriptionsTableCreateCompanionBuilder,
          $$SubscriptionsTableUpdateCompanionBuilder,
          (SubscriptionRow, $$SubscriptionsTableReferences),
          SubscriptionRow,
          PrefetchHooks Function({
            bool episodeCacheRefs,
            bool playbackProgressRefs,
            bool downloadsRefs,
          })
        > {
  $$SubscriptionsTableTableManager(_$AppDatabase db, $SubscriptionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SubscriptionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SubscriptionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SubscriptionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> author = const Value.absent(),
                Value<String> feedUrl = const Value.absent(),
                Value<String?> artworkUrl = const Value.absent(),
                Value<String?> genre = const Value.absent(),
                Value<int> episodeCount = const Value.absent(),
                Value<DateTime> subscribedAt = const Value.absent(),
                Value<DateTime?> lastRefreshedAt = const Value.absent(),
                Value<String> autoDownload = const Value.absent(),
                Value<int> autoDownloadLimit = const Value.absent(),
                Value<int> autoDeletePlayedDays = const Value.absent(),
                Value<double?> playbackSpeedOverride = const Value.absent(),
              }) => SubscriptionsCompanion(
                id: id,
                title: title,
                author: author,
                feedUrl: feedUrl,
                artworkUrl: artworkUrl,
                genre: genre,
                episodeCount: episodeCount,
                subscribedAt: subscribedAt,
                lastRefreshedAt: lastRefreshedAt,
                autoDownload: autoDownload,
                autoDownloadLimit: autoDownloadLimit,
                autoDeletePlayedDays: autoDeletePlayedDays,
                playbackSpeedOverride: playbackSpeedOverride,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String title,
                required String author,
                required String feedUrl,
                Value<String?> artworkUrl = const Value.absent(),
                Value<String?> genre = const Value.absent(),
                Value<int> episodeCount = const Value.absent(),
                Value<DateTime> subscribedAt = const Value.absent(),
                Value<DateTime?> lastRefreshedAt = const Value.absent(),
                Value<String> autoDownload = const Value.absent(),
                Value<int> autoDownloadLimit = const Value.absent(),
                Value<int> autoDeletePlayedDays = const Value.absent(),
                Value<double?> playbackSpeedOverride = const Value.absent(),
              }) => SubscriptionsCompanion.insert(
                id: id,
                title: title,
                author: author,
                feedUrl: feedUrl,
                artworkUrl: artworkUrl,
                genre: genre,
                episodeCount: episodeCount,
                subscribedAt: subscribedAt,
                lastRefreshedAt: lastRefreshedAt,
                autoDownload: autoDownload,
                autoDownloadLimit: autoDownloadLimit,
                autoDeletePlayedDays: autoDeletePlayedDays,
                playbackSpeedOverride: playbackSpeedOverride,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SubscriptionsTable, SubscriptionRow>(table),
                  $$SubscriptionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                episodeCacheRefs = false,
                playbackProgressRefs = false,
                downloadsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (episodeCacheRefs) db.episodeCache,
                    if (playbackProgressRefs) db.playbackProgress,
                    if (downloadsRefs) db.downloads,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (episodeCacheRefs)
                        await $_getPrefetchedData<
                          SubscriptionRow,
                          $SubscriptionsTable,
                          EpisodeCacheRow
                        >(
                          currentTable: table,
                          referencedTable: $$SubscriptionsTableReferences
                              ._episodeCacheRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SubscriptionsTableReferences(
                                db,
                                table,
                                p0,
                              ).episodeCacheRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.podcastId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (playbackProgressRefs)
                        await $_getPrefetchedData<
                          SubscriptionRow,
                          $SubscriptionsTable,
                          PlaybackProgressRow
                        >(
                          currentTable: table,
                          referencedTable: $$SubscriptionsTableReferences
                              ._playbackProgressRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SubscriptionsTableReferences(
                                db,
                                table,
                                p0,
                              ).playbackProgressRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.podcastId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (downloadsRefs)
                        await $_getPrefetchedData<
                          SubscriptionRow,
                          $SubscriptionsTable,
                          DownloadRow
                        >(
                          currentTable: table,
                          referencedTable: $$SubscriptionsTableReferences
                              ._downloadsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SubscriptionsTableReferences(
                                db,
                                table,
                                p0,
                              ).downloadsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.podcastId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$SubscriptionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SubscriptionsTable,
      SubscriptionRow,
      $$SubscriptionsTableFilterComposer,
      $$SubscriptionsTableOrderingComposer,
      $$SubscriptionsTableAnnotationComposer,
      $$SubscriptionsTableCreateCompanionBuilder,
      $$SubscriptionsTableUpdateCompanionBuilder,
      (SubscriptionRow, $$SubscriptionsTableReferences),
      SubscriptionRow,
      PrefetchHooks Function({
        bool episodeCacheRefs,
        bool playbackProgressRefs,
        bool downloadsRefs,
      })
    >;
typedef $$EpisodeCacheTableCreateCompanionBuilder =
    EpisodeCacheCompanion Function({
      required int podcastId,
      required String guid,
      required String title,
      required String audioUrl,
      Value<String?> description,
      Value<String?> imageUrl,
      Value<int?> durationSeconds,
      Value<DateTime?> publishedAt,
      Value<DateTime?> addedAt,
      Value<bool> archived,
      Value<int?> seasonNumber,
      Value<int?> episodeNumber,
      Value<String?> episodeType,
      Value<String?> link,
      Value<String?> chaptersUrl,
      Value<int> rowid,
    });
typedef $$EpisodeCacheTableUpdateCompanionBuilder =
    EpisodeCacheCompanion Function({
      Value<int> podcastId,
      Value<String> guid,
      Value<String> title,
      Value<String> audioUrl,
      Value<String?> description,
      Value<String?> imageUrl,
      Value<int?> durationSeconds,
      Value<DateTime?> publishedAt,
      Value<DateTime?> addedAt,
      Value<bool> archived,
      Value<int?> seasonNumber,
      Value<int?> episodeNumber,
      Value<String?> episodeType,
      Value<String?> link,
      Value<String?> chaptersUrl,
      Value<int> rowid,
    });

final class $$EpisodeCacheTableReferences
    extends BaseReferences<_$AppDatabase, $EpisodeCacheTable, EpisodeCacheRow> {
  $$EpisodeCacheTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SubscriptionsTable _podcastIdTable(_$AppDatabase db) => db
      .subscriptions
      .createAlias('episode_cache__podcast_id__subscriptions__id');

  $$SubscriptionsTableProcessedTableManager get podcastId {
    final $_column = $_itemColumn<int>('podcast_id')!;

    final manager = $$SubscriptionsTableTableManager(
      $_db,
      $_db.subscriptions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_podcastIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$EpisodeCacheTableFilterComposer
    extends Composer<_$AppDatabase, $EpisodeCacheTable> {
  $$EpisodeCacheTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get guid => $composableBuilder(
    column: $table.guid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get audioUrl => $composableBuilder(
    column: $table.audioUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get publishedAt => $composableBuilder(
    column: $table.publishedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get addedAt => $composableBuilder(
    column: $table.addedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get archived => $composableBuilder(
    column: $table.archived,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get seasonNumber => $composableBuilder(
    column: $table.seasonNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get episodeNumber => $composableBuilder(
    column: $table.episodeNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get episodeType => $composableBuilder(
    column: $table.episodeType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get link => $composableBuilder(
    column: $table.link,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get chaptersUrl => $composableBuilder(
    column: $table.chaptersUrl,
    builder: (column) => ColumnFilters(column),
  );

  $$SubscriptionsTableFilterComposer get podcastId {
    final $$SubscriptionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.podcastId,
      referencedTable: $db.subscriptions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubscriptionsTableFilterComposer(
            $db: $db,
            $table: $db.subscriptions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EpisodeCacheTableOrderingComposer
    extends Composer<_$AppDatabase, $EpisodeCacheTable> {
  $$EpisodeCacheTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get guid => $composableBuilder(
    column: $table.guid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get audioUrl => $composableBuilder(
    column: $table.audioUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get publishedAt => $composableBuilder(
    column: $table.publishedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get addedAt => $composableBuilder(
    column: $table.addedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get archived => $composableBuilder(
    column: $table.archived,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get seasonNumber => $composableBuilder(
    column: $table.seasonNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get episodeNumber => $composableBuilder(
    column: $table.episodeNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get episodeType => $composableBuilder(
    column: $table.episodeType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get link => $composableBuilder(
    column: $table.link,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get chaptersUrl => $composableBuilder(
    column: $table.chaptersUrl,
    builder: (column) => ColumnOrderings(column),
  );

  $$SubscriptionsTableOrderingComposer get podcastId {
    final $$SubscriptionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.podcastId,
      referencedTable: $db.subscriptions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubscriptionsTableOrderingComposer(
            $db: $db,
            $table: $db.subscriptions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EpisodeCacheTableAnnotationComposer
    extends Composer<_$AppDatabase, $EpisodeCacheTable> {
  $$EpisodeCacheTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get guid =>
      $composableBuilder(column: $table.guid, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get audioUrl =>
      $composableBuilder(column: $table.audioUrl, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get imageUrl =>
      $composableBuilder(column: $table.imageUrl, builder: (column) => column);

  GeneratedColumn<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get publishedAt => $composableBuilder(
    column: $table.publishedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get addedAt =>
      $composableBuilder(column: $table.addedAt, builder: (column) => column);

  GeneratedColumn<bool> get archived =>
      $composableBuilder(column: $table.archived, builder: (column) => column);

  GeneratedColumn<int> get seasonNumber => $composableBuilder(
    column: $table.seasonNumber,
    builder: (column) => column,
  );

  GeneratedColumn<int> get episodeNumber => $composableBuilder(
    column: $table.episodeNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get episodeType => $composableBuilder(
    column: $table.episodeType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get link =>
      $composableBuilder(column: $table.link, builder: (column) => column);

  GeneratedColumn<String> get chaptersUrl => $composableBuilder(
    column: $table.chaptersUrl,
    builder: (column) => column,
  );

  $$SubscriptionsTableAnnotationComposer get podcastId {
    final $$SubscriptionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.podcastId,
      referencedTable: $db.subscriptions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubscriptionsTableAnnotationComposer(
            $db: $db,
            $table: $db.subscriptions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EpisodeCacheTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EpisodeCacheTable,
          EpisodeCacheRow,
          $$EpisodeCacheTableFilterComposer,
          $$EpisodeCacheTableOrderingComposer,
          $$EpisodeCacheTableAnnotationComposer,
          $$EpisodeCacheTableCreateCompanionBuilder,
          $$EpisodeCacheTableUpdateCompanionBuilder,
          (EpisodeCacheRow, $$EpisodeCacheTableReferences),
          EpisodeCacheRow,
          PrefetchHooks Function({bool podcastId})
        > {
  $$EpisodeCacheTableTableManager(_$AppDatabase db, $EpisodeCacheTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EpisodeCacheTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EpisodeCacheTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EpisodeCacheTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> podcastId = const Value.absent(),
                Value<String> guid = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> audioUrl = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> imageUrl = const Value.absent(),
                Value<int?> durationSeconds = const Value.absent(),
                Value<DateTime?> publishedAt = const Value.absent(),
                Value<DateTime?> addedAt = const Value.absent(),
                Value<bool> archived = const Value.absent(),
                Value<int?> seasonNumber = const Value.absent(),
                Value<int?> episodeNumber = const Value.absent(),
                Value<String?> episodeType = const Value.absent(),
                Value<String?> link = const Value.absent(),
                Value<String?> chaptersUrl = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EpisodeCacheCompanion(
                podcastId: podcastId,
                guid: guid,
                title: title,
                audioUrl: audioUrl,
                description: description,
                imageUrl: imageUrl,
                durationSeconds: durationSeconds,
                publishedAt: publishedAt,
                addedAt: addedAt,
                archived: archived,
                seasonNumber: seasonNumber,
                episodeNumber: episodeNumber,
                episodeType: episodeType,
                link: link,
                chaptersUrl: chaptersUrl,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int podcastId,
                required String guid,
                required String title,
                required String audioUrl,
                Value<String?> description = const Value.absent(),
                Value<String?> imageUrl = const Value.absent(),
                Value<int?> durationSeconds = const Value.absent(),
                Value<DateTime?> publishedAt = const Value.absent(),
                Value<DateTime?> addedAt = const Value.absent(),
                Value<bool> archived = const Value.absent(),
                Value<int?> seasonNumber = const Value.absent(),
                Value<int?> episodeNumber = const Value.absent(),
                Value<String?> episodeType = const Value.absent(),
                Value<String?> link = const Value.absent(),
                Value<String?> chaptersUrl = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EpisodeCacheCompanion.insert(
                podcastId: podcastId,
                guid: guid,
                title: title,
                audioUrl: audioUrl,
                description: description,
                imageUrl: imageUrl,
                durationSeconds: durationSeconds,
                publishedAt: publishedAt,
                addedAt: addedAt,
                archived: archived,
                seasonNumber: seasonNumber,
                episodeNumber: episodeNumber,
                episodeType: episodeType,
                link: link,
                chaptersUrl: chaptersUrl,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$EpisodeCacheTable, EpisodeCacheRow>(table),
                  $$EpisodeCacheTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({podcastId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (podcastId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.podcastId,
                        referencedTable: $$EpisodeCacheTableReferences
                            ._podcastIdTable(db),
                        referencedColumn: $$EpisodeCacheTableReferences
                            ._podcastIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$EpisodeCacheTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EpisodeCacheTable,
      EpisodeCacheRow,
      $$EpisodeCacheTableFilterComposer,
      $$EpisodeCacheTableOrderingComposer,
      $$EpisodeCacheTableAnnotationComposer,
      $$EpisodeCacheTableCreateCompanionBuilder,
      $$EpisodeCacheTableUpdateCompanionBuilder,
      (EpisodeCacheRow, $$EpisodeCacheTableReferences),
      EpisodeCacheRow,
      PrefetchHooks Function({bool podcastId})
    >;
typedef $$PlaybackProgressTableCreateCompanionBuilder =
    PlaybackProgressCompanion Function({
      required int podcastId,
      required String episodeGuid,
      Value<int> positionSeconds,
      Value<bool> completed,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$PlaybackProgressTableUpdateCompanionBuilder =
    PlaybackProgressCompanion Function({
      Value<int> podcastId,
      Value<String> episodeGuid,
      Value<int> positionSeconds,
      Value<bool> completed,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$PlaybackProgressTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $PlaybackProgressTable,
          PlaybackProgressRow
        > {
  $$PlaybackProgressTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $SubscriptionsTable _podcastIdTable(_$AppDatabase db) => db
      .subscriptions
      .createAlias('playback_progress__podcast_id__subscriptions__id');

  $$SubscriptionsTableProcessedTableManager get podcastId {
    final $_column = $_itemColumn<int>('podcast_id')!;

    final manager = $$SubscriptionsTableTableManager(
      $_db,
      $_db.subscriptions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_podcastIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PlaybackProgressTableFilterComposer
    extends Composer<_$AppDatabase, $PlaybackProgressTable> {
  $$PlaybackProgressTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get episodeGuid => $composableBuilder(
    column: $table.episodeGuid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get positionSeconds => $composableBuilder(
    column: $table.positionSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get completed => $composableBuilder(
    column: $table.completed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$SubscriptionsTableFilterComposer get podcastId {
    final $$SubscriptionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.podcastId,
      referencedTable: $db.subscriptions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubscriptionsTableFilterComposer(
            $db: $db,
            $table: $db.subscriptions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PlaybackProgressTableOrderingComposer
    extends Composer<_$AppDatabase, $PlaybackProgressTable> {
  $$PlaybackProgressTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get episodeGuid => $composableBuilder(
    column: $table.episodeGuid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get positionSeconds => $composableBuilder(
    column: $table.positionSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get completed => $composableBuilder(
    column: $table.completed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$SubscriptionsTableOrderingComposer get podcastId {
    final $$SubscriptionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.podcastId,
      referencedTable: $db.subscriptions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubscriptionsTableOrderingComposer(
            $db: $db,
            $table: $db.subscriptions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PlaybackProgressTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlaybackProgressTable> {
  $$PlaybackProgressTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get episodeGuid => $composableBuilder(
    column: $table.episodeGuid,
    builder: (column) => column,
  );

  GeneratedColumn<int> get positionSeconds => $composableBuilder(
    column: $table.positionSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get completed =>
      $composableBuilder(column: $table.completed, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$SubscriptionsTableAnnotationComposer get podcastId {
    final $$SubscriptionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.podcastId,
      referencedTable: $db.subscriptions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubscriptionsTableAnnotationComposer(
            $db: $db,
            $table: $db.subscriptions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PlaybackProgressTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PlaybackProgressTable,
          PlaybackProgressRow,
          $$PlaybackProgressTableFilterComposer,
          $$PlaybackProgressTableOrderingComposer,
          $$PlaybackProgressTableAnnotationComposer,
          $$PlaybackProgressTableCreateCompanionBuilder,
          $$PlaybackProgressTableUpdateCompanionBuilder,
          (PlaybackProgressRow, $$PlaybackProgressTableReferences),
          PlaybackProgressRow,
          PrefetchHooks Function({bool podcastId})
        > {
  $$PlaybackProgressTableTableManager(
    _$AppDatabase db,
    $PlaybackProgressTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlaybackProgressTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlaybackProgressTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlaybackProgressTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> podcastId = const Value.absent(),
                Value<String> episodeGuid = const Value.absent(),
                Value<int> positionSeconds = const Value.absent(),
                Value<bool> completed = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PlaybackProgressCompanion(
                podcastId: podcastId,
                episodeGuid: episodeGuid,
                positionSeconds: positionSeconds,
                completed: completed,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int podcastId,
                required String episodeGuid,
                Value<int> positionSeconds = const Value.absent(),
                Value<bool> completed = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PlaybackProgressCompanion.insert(
                podcastId: podcastId,
                episodeGuid: episodeGuid,
                positionSeconds: positionSeconds,
                completed: completed,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PlaybackProgressTable, PlaybackProgressRow>(
                    table,
                  ),
                  $$PlaybackProgressTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({podcastId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (podcastId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.podcastId,
                        referencedTable: $$PlaybackProgressTableReferences
                            ._podcastIdTable(db),
                        referencedColumn: $$PlaybackProgressTableReferences
                            ._podcastIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PlaybackProgressTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PlaybackProgressTable,
      PlaybackProgressRow,
      $$PlaybackProgressTableFilterComposer,
      $$PlaybackProgressTableOrderingComposer,
      $$PlaybackProgressTableAnnotationComposer,
      $$PlaybackProgressTableCreateCompanionBuilder,
      $$PlaybackProgressTableUpdateCompanionBuilder,
      (PlaybackProgressRow, $$PlaybackProgressTableReferences),
      PlaybackProgressRow,
      PrefetchHooks Function({bool podcastId})
    >;
typedef $$DownloadsTableCreateCompanionBuilder = DownloadsCompanion Function({
  required int podcastId,
  required String episodeGuid,
  Value<String?> taskId,
  Value<String?> localPath,
  Value<String> status,
  Value<int> progress,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});
typedef $$DownloadsTableUpdateCompanionBuilder = DownloadsCompanion Function({
  Value<int> podcastId,
  Value<String> episodeGuid,
  Value<String?> taskId,
  Value<String?> localPath,
  Value<String> status,
  Value<int> progress,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

final class $$DownloadsTableReferences
    extends BaseReferences<_$AppDatabase, $DownloadsTable, DownloadRow> {
  $$DownloadsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SubscriptionsTable _podcastIdTable(_$AppDatabase db) =>
      db.subscriptions.createAlias('downloads__podcast_id__subscriptions__id');

  $$SubscriptionsTableProcessedTableManager get podcastId {
    final $_column = $_itemColumn<int>('podcast_id')!;

    final manager = $$SubscriptionsTableTableManager(
      $_db,
      $_db.subscriptions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_podcastIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$DownloadsTableFilterComposer
    extends Composer<_$AppDatabase, $DownloadsTable> {
  $$DownloadsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get episodeGuid => $composableBuilder(
    column: $table.episodeGuid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get taskId => $composableBuilder(
    column: $table.taskId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localPath => $composableBuilder(
    column: $table.localPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get progress => $composableBuilder(
    column: $table.progress,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$SubscriptionsTableFilterComposer get podcastId {
    final $$SubscriptionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.podcastId,
      referencedTable: $db.subscriptions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubscriptionsTableFilterComposer(
            $db: $db,
            $table: $db.subscriptions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DownloadsTableOrderingComposer
    extends Composer<_$AppDatabase, $DownloadsTable> {
  $$DownloadsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get episodeGuid => $composableBuilder(
    column: $table.episodeGuid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get taskId => $composableBuilder(
    column: $table.taskId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localPath => $composableBuilder(
    column: $table.localPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get progress => $composableBuilder(
    column: $table.progress,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$SubscriptionsTableOrderingComposer get podcastId {
    final $$SubscriptionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.podcastId,
      referencedTable: $db.subscriptions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubscriptionsTableOrderingComposer(
            $db: $db,
            $table: $db.subscriptions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DownloadsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DownloadsTable> {
  $$DownloadsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get episodeGuid => $composableBuilder(
    column: $table.episodeGuid,
    builder: (column) => column,
  );

  GeneratedColumn<String> get taskId =>
      $composableBuilder(column: $table.taskId, builder: (column) => column);

  GeneratedColumn<String> get localPath =>
      $composableBuilder(column: $table.localPath, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get progress =>
      $composableBuilder(column: $table.progress, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$SubscriptionsTableAnnotationComposer get podcastId {
    final $$SubscriptionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.podcastId,
      referencedTable: $db.subscriptions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubscriptionsTableAnnotationComposer(
            $db: $db,
            $table: $db.subscriptions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DownloadsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DownloadsTable,
          DownloadRow,
          $$DownloadsTableFilterComposer,
          $$DownloadsTableOrderingComposer,
          $$DownloadsTableAnnotationComposer,
          $$DownloadsTableCreateCompanionBuilder,
          $$DownloadsTableUpdateCompanionBuilder,
          (DownloadRow, $$DownloadsTableReferences),
          DownloadRow,
          PrefetchHooks Function({bool podcastId})
        > {
  $$DownloadsTableTableManager(_$AppDatabase db, $DownloadsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DownloadsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DownloadsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DownloadsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> podcastId = const Value.absent(),
                Value<String> episodeGuid = const Value.absent(),
                Value<String?> taskId = const Value.absent(),
                Value<String?> localPath = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> progress = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DownloadsCompanion(
                podcastId: podcastId,
                episodeGuid: episodeGuid,
                taskId: taskId,
                localPath: localPath,
                status: status,
                progress: progress,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int podcastId,
                required String episodeGuid,
                Value<String?> taskId = const Value.absent(),
                Value<String?> localPath = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> progress = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DownloadsCompanion.insert(
                podcastId: podcastId,
                episodeGuid: episodeGuid,
                taskId: taskId,
                localPath: localPath,
                status: status,
                progress: progress,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DownloadsTable, DownloadRow>(table),
                  $$DownloadsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({podcastId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (podcastId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.podcastId,
                        referencedTable: $$DownloadsTableReferences
                            ._podcastIdTable(db),
                        referencedColumn: $$DownloadsTableReferences
                            ._podcastIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$DownloadsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DownloadsTable,
      DownloadRow,
      $$DownloadsTableFilterComposer,
      $$DownloadsTableOrderingComposer,
      $$DownloadsTableAnnotationComposer,
      $$DownloadsTableCreateCompanionBuilder,
      $$DownloadsTableUpdateCompanionBuilder,
      (DownloadRow, $$DownloadsTableReferences),
      DownloadRow,
      PrefetchHooks Function({bool podcastId})
    >;
typedef $$QueueItemsTableCreateCompanionBuilder = QueueItemsCompanion Function({
  required int position,
  required int podcastId,
  required String podcastTitle,
  required String podcastAuthor,
  required String podcastFeedUrl,
  Value<String?> podcastArtworkUrl,
  required String episodeGuid,
  required String episodeTitle,
  required String audioUrl,
  Value<String?> episodeImageUrl,
  Value<int?> episodeDurationSeconds,
  Value<DateTime?> episodePublishedAt,
  Value<DateTime> addedAt,
  Value<int> rowid,
});
typedef $$QueueItemsTableUpdateCompanionBuilder = QueueItemsCompanion Function({
  Value<int> position,
  Value<int> podcastId,
  Value<String> podcastTitle,
  Value<String> podcastAuthor,
  Value<String> podcastFeedUrl,
  Value<String?> podcastArtworkUrl,
  Value<String> episodeGuid,
  Value<String> episodeTitle,
  Value<String> audioUrl,
  Value<String?> episodeImageUrl,
  Value<int?> episodeDurationSeconds,
  Value<DateTime?> episodePublishedAt,
  Value<DateTime> addedAt,
  Value<int> rowid,
});

class $$QueueItemsTableFilterComposer
    extends Composer<_$AppDatabase, $QueueItemsTable> {
  $$QueueItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get podcastId => $composableBuilder(
    column: $table.podcastId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get podcastTitle => $composableBuilder(
    column: $table.podcastTitle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get podcastAuthor => $composableBuilder(
    column: $table.podcastAuthor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get podcastFeedUrl => $composableBuilder(
    column: $table.podcastFeedUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get podcastArtworkUrl => $composableBuilder(
    column: $table.podcastArtworkUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get episodeGuid => $composableBuilder(
    column: $table.episodeGuid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get episodeTitle => $composableBuilder(
    column: $table.episodeTitle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get audioUrl => $composableBuilder(
    column: $table.audioUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get episodeImageUrl => $composableBuilder(
    column: $table.episodeImageUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get episodeDurationSeconds => $composableBuilder(
    column: $table.episodeDurationSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get episodePublishedAt => $composableBuilder(
    column: $table.episodePublishedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get addedAt => $composableBuilder(
    column: $table.addedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$QueueItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $QueueItemsTable> {
  $$QueueItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get podcastId => $composableBuilder(
    column: $table.podcastId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get podcastTitle => $composableBuilder(
    column: $table.podcastTitle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get podcastAuthor => $composableBuilder(
    column: $table.podcastAuthor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get podcastFeedUrl => $composableBuilder(
    column: $table.podcastFeedUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get podcastArtworkUrl => $composableBuilder(
    column: $table.podcastArtworkUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get episodeGuid => $composableBuilder(
    column: $table.episodeGuid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get episodeTitle => $composableBuilder(
    column: $table.episodeTitle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get audioUrl => $composableBuilder(
    column: $table.audioUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get episodeImageUrl => $composableBuilder(
    column: $table.episodeImageUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get episodeDurationSeconds => $composableBuilder(
    column: $table.episodeDurationSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get episodePublishedAt => $composableBuilder(
    column: $table.episodePublishedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get addedAt => $composableBuilder(
    column: $table.addedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$QueueItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $QueueItemsTable> {
  $$QueueItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<int> get podcastId =>
      $composableBuilder(column: $table.podcastId, builder: (column) => column);

  GeneratedColumn<String> get podcastTitle => $composableBuilder(
    column: $table.podcastTitle,
    builder: (column) => column,
  );

  GeneratedColumn<String> get podcastAuthor => $composableBuilder(
    column: $table.podcastAuthor,
    builder: (column) => column,
  );

  GeneratedColumn<String> get podcastFeedUrl => $composableBuilder(
    column: $table.podcastFeedUrl,
    builder: (column) => column,
  );

  GeneratedColumn<String> get podcastArtworkUrl => $composableBuilder(
    column: $table.podcastArtworkUrl,
    builder: (column) => column,
  );

  GeneratedColumn<String> get episodeGuid => $composableBuilder(
    column: $table.episodeGuid,
    builder: (column) => column,
  );

  GeneratedColumn<String> get episodeTitle => $composableBuilder(
    column: $table.episodeTitle,
    builder: (column) => column,
  );

  GeneratedColumn<String> get audioUrl =>
      $composableBuilder(column: $table.audioUrl, builder: (column) => column);

  GeneratedColumn<String> get episodeImageUrl => $composableBuilder(
    column: $table.episodeImageUrl,
    builder: (column) => column,
  );

  GeneratedColumn<int> get episodeDurationSeconds => $composableBuilder(
    column: $table.episodeDurationSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get episodePublishedAt => $composableBuilder(
    column: $table.episodePublishedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get addedAt =>
      $composableBuilder(column: $table.addedAt, builder: (column) => column);
}

class $$QueueItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $QueueItemsTable,
          QueueItemRow,
          $$QueueItemsTableFilterComposer,
          $$QueueItemsTableOrderingComposer,
          $$QueueItemsTableAnnotationComposer,
          $$QueueItemsTableCreateCompanionBuilder,
          $$QueueItemsTableUpdateCompanionBuilder,
          (
            QueueItemRow,
            BaseReferences<_$AppDatabase, $QueueItemsTable, QueueItemRow>,
          ),
          QueueItemRow,
          PrefetchHooks Function()
        > {
  $$QueueItemsTableTableManager(_$AppDatabase db, $QueueItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QueueItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QueueItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$QueueItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> position = const Value.absent(),
                Value<int> podcastId = const Value.absent(),
                Value<String> podcastTitle = const Value.absent(),
                Value<String> podcastAuthor = const Value.absent(),
                Value<String> podcastFeedUrl = const Value.absent(),
                Value<String?> podcastArtworkUrl = const Value.absent(),
                Value<String> episodeGuid = const Value.absent(),
                Value<String> episodeTitle = const Value.absent(),
                Value<String> audioUrl = const Value.absent(),
                Value<String?> episodeImageUrl = const Value.absent(),
                Value<int?> episodeDurationSeconds = const Value.absent(),
                Value<DateTime?> episodePublishedAt = const Value.absent(),
                Value<DateTime> addedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => QueueItemsCompanion(
                position: position,
                podcastId: podcastId,
                podcastTitle: podcastTitle,
                podcastAuthor: podcastAuthor,
                podcastFeedUrl: podcastFeedUrl,
                podcastArtworkUrl: podcastArtworkUrl,
                episodeGuid: episodeGuid,
                episodeTitle: episodeTitle,
                audioUrl: audioUrl,
                episodeImageUrl: episodeImageUrl,
                episodeDurationSeconds: episodeDurationSeconds,
                episodePublishedAt: episodePublishedAt,
                addedAt: addedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int position,
                required int podcastId,
                required String podcastTitle,
                required String podcastAuthor,
                required String podcastFeedUrl,
                Value<String?> podcastArtworkUrl = const Value.absent(),
                required String episodeGuid,
                required String episodeTitle,
                required String audioUrl,
                Value<String?> episodeImageUrl = const Value.absent(),
                Value<int?> episodeDurationSeconds = const Value.absent(),
                Value<DateTime?> episodePublishedAt = const Value.absent(),
                Value<DateTime> addedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => QueueItemsCompanion.insert(
                position: position,
                podcastId: podcastId,
                podcastTitle: podcastTitle,
                podcastAuthor: podcastAuthor,
                podcastFeedUrl: podcastFeedUrl,
                podcastArtworkUrl: podcastArtworkUrl,
                episodeGuid: episodeGuid,
                episodeTitle: episodeTitle,
                audioUrl: audioUrl,
                episodeImageUrl: episodeImageUrl,
                episodeDurationSeconds: episodeDurationSeconds,
                episodePublishedAt: episodePublishedAt,
                addedAt: addedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$QueueItemsTable, QueueItemRow>(table),
                  BaseReferences<_$AppDatabase, $QueueItemsTable, QueueItemRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$QueueItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $QueueItemsTable,
      QueueItemRow,
      $$QueueItemsTableFilterComposer,
      $$QueueItemsTableOrderingComposer,
      $$QueueItemsTableAnnotationComposer,
      $$QueueItemsTableCreateCompanionBuilder,
      $$QueueItemsTableUpdateCompanionBuilder,
      (
        QueueItemRow,
        BaseReferences<_$AppDatabase, $QueueItemsTable, QueueItemRow>,
      ),
      QueueItemRow,
      PrefetchHooks Function()
    >;
typedef $$ChaptersTableCreateCompanionBuilder = ChaptersCompanion Function({
  required int podcastId,
  required String episodeGuid,
  required int startMs,
  required String title,
  Value<String?> imageUrl,
  Value<int> rowid,
});
typedef $$ChaptersTableUpdateCompanionBuilder = ChaptersCompanion Function({
  Value<int> podcastId,
  Value<String> episodeGuid,
  Value<int> startMs,
  Value<String> title,
  Value<String?> imageUrl,
  Value<int> rowid,
});

class $$ChaptersTableFilterComposer
    extends Composer<_$AppDatabase, $ChaptersTable> {
  $$ChaptersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get podcastId => $composableBuilder(
    column: $table.podcastId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get episodeGuid => $composableBuilder(
    column: $table.episodeGuid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startMs => $composableBuilder(
    column: $table.startMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ChaptersTableOrderingComposer
    extends Composer<_$AppDatabase, $ChaptersTable> {
  $$ChaptersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get podcastId => $composableBuilder(
    column: $table.podcastId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get episodeGuid => $composableBuilder(
    column: $table.episodeGuid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startMs => $composableBuilder(
    column: $table.startMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ChaptersTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChaptersTable> {
  $$ChaptersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get podcastId =>
      $composableBuilder(column: $table.podcastId, builder: (column) => column);

  GeneratedColumn<String> get episodeGuid => $composableBuilder(
    column: $table.episodeGuid,
    builder: (column) => column,
  );

  GeneratedColumn<int> get startMs =>
      $composableBuilder(column: $table.startMs, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get imageUrl =>
      $composableBuilder(column: $table.imageUrl, builder: (column) => column);
}

class $$ChaptersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ChaptersTable,
          ChapterRow,
          $$ChaptersTableFilterComposer,
          $$ChaptersTableOrderingComposer,
          $$ChaptersTableAnnotationComposer,
          $$ChaptersTableCreateCompanionBuilder,
          $$ChaptersTableUpdateCompanionBuilder,
          (
            ChapterRow,
            BaseReferences<_$AppDatabase, $ChaptersTable, ChapterRow>,
          ),
          ChapterRow,
          PrefetchHooks Function()
        > {
  $$ChaptersTableTableManager(_$AppDatabase db, $ChaptersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChaptersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChaptersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChaptersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> podcastId = const Value.absent(),
                Value<String> episodeGuid = const Value.absent(),
                Value<int> startMs = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> imageUrl = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChaptersCompanion(
                podcastId: podcastId,
                episodeGuid: episodeGuid,
                startMs: startMs,
                title: title,
                imageUrl: imageUrl,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int podcastId,
                required String episodeGuid,
                required int startMs,
                required String title,
                Value<String?> imageUrl = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChaptersCompanion.insert(
                podcastId: podcastId,
                episodeGuid: episodeGuid,
                startMs: startMs,
                title: title,
                imageUrl: imageUrl,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ChaptersTable, ChapterRow>(table),
                  BaseReferences<_$AppDatabase, $ChaptersTable, ChapterRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ChaptersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ChaptersTable,
      ChapterRow,
      $$ChaptersTableFilterComposer,
      $$ChaptersTableOrderingComposer,
      $$ChaptersTableAnnotationComposer,
      $$ChaptersTableCreateCompanionBuilder,
      $$ChaptersTableUpdateCompanionBuilder,
      (ChapterRow, BaseReferences<_$AppDatabase, $ChaptersTable, ChapterRow>),
      ChapterRow,
      PrefetchHooks Function()
    >;
typedef $$ListenHistoryTableCreateCompanionBuilder =
    ListenHistoryCompanion Function({
      required int podcastId,
      required String episodeGuid,
      required DateTime day,
      Value<int> secondsListened,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$ListenHistoryTableUpdateCompanionBuilder =
    ListenHistoryCompanion Function({
      Value<int> podcastId,
      Value<String> episodeGuid,
      Value<DateTime> day,
      Value<int> secondsListened,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$ListenHistoryTableFilterComposer
    extends Composer<_$AppDatabase, $ListenHistoryTable> {
  $$ListenHistoryTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get podcastId => $composableBuilder(
    column: $table.podcastId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get episodeGuid => $composableBuilder(
    column: $table.episodeGuid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get day => $composableBuilder(
    column: $table.day,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get secondsListened => $composableBuilder(
    column: $table.secondsListened,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ListenHistoryTableOrderingComposer
    extends Composer<_$AppDatabase, $ListenHistoryTable> {
  $$ListenHistoryTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get podcastId => $composableBuilder(
    column: $table.podcastId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get episodeGuid => $composableBuilder(
    column: $table.episodeGuid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get day => $composableBuilder(
    column: $table.day,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get secondsListened => $composableBuilder(
    column: $table.secondsListened,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ListenHistoryTableAnnotationComposer
    extends Composer<_$AppDatabase, $ListenHistoryTable> {
  $$ListenHistoryTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get podcastId =>
      $composableBuilder(column: $table.podcastId, builder: (column) => column);

  GeneratedColumn<String> get episodeGuid => $composableBuilder(
    column: $table.episodeGuid,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get day =>
      $composableBuilder(column: $table.day, builder: (column) => column);

  GeneratedColumn<int> get secondsListened => $composableBuilder(
    column: $table.secondsListened,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ListenHistoryTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ListenHistoryTable,
          ListenHistoryRow,
          $$ListenHistoryTableFilterComposer,
          $$ListenHistoryTableOrderingComposer,
          $$ListenHistoryTableAnnotationComposer,
          $$ListenHistoryTableCreateCompanionBuilder,
          $$ListenHistoryTableUpdateCompanionBuilder,
          (
            ListenHistoryRow,
            BaseReferences<
              _$AppDatabase,
              $ListenHistoryTable,
              ListenHistoryRow
            >,
          ),
          ListenHistoryRow,
          PrefetchHooks Function()
        > {
  $$ListenHistoryTableTableManager(_$AppDatabase db, $ListenHistoryTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ListenHistoryTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ListenHistoryTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ListenHistoryTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> podcastId = const Value.absent(),
                Value<String> episodeGuid = const Value.absent(),
                Value<DateTime> day = const Value.absent(),
                Value<int> secondsListened = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ListenHistoryCompanion(
                podcastId: podcastId,
                episodeGuid: episodeGuid,
                day: day,
                secondsListened: secondsListened,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int podcastId,
                required String episodeGuid,
                required DateTime day,
                Value<int> secondsListened = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ListenHistoryCompanion.insert(
                podcastId: podcastId,
                episodeGuid: episodeGuid,
                day: day,
                secondsListened: secondsListened,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ListenHistoryTable, ListenHistoryRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $ListenHistoryTable,
                    ListenHistoryRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ListenHistoryTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ListenHistoryTable,
      ListenHistoryRow,
      $$ListenHistoryTableFilterComposer,
      $$ListenHistoryTableOrderingComposer,
      $$ListenHistoryTableAnnotationComposer,
      $$ListenHistoryTableCreateCompanionBuilder,
      $$ListenHistoryTableUpdateCompanionBuilder,
      (
        ListenHistoryRow,
        BaseReferences<_$AppDatabase, $ListenHistoryTable, ListenHistoryRow>,
      ),
      ListenHistoryRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SubscriptionsTableTableManager get subscriptions =>
      $$SubscriptionsTableTableManager(_db, _db.subscriptions);
  $$EpisodeCacheTableTableManager get episodeCache =>
      $$EpisodeCacheTableTableManager(_db, _db.episodeCache);
  $$PlaybackProgressTableTableManager get playbackProgress =>
      $$PlaybackProgressTableTableManager(_db, _db.playbackProgress);
  $$DownloadsTableTableManager get downloads =>
      $$DownloadsTableTableManager(_db, _db.downloads);
  $$QueueItemsTableTableManager get queueItems =>
      $$QueueItemsTableTableManager(_db, _db.queueItems);
  $$ChaptersTableTableManager get chapters =>
      $$ChaptersTableTableManager(_db, _db.chapters);
  $$ListenHistoryTableTableManager get listenHistory =>
      $$ListenHistoryTableTableManager(_db, _db.listenHistory);
}

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// `keepAlive`: a conexão com o banco vive pelo tempo do app — recriar a
/// cada tela seria caro e arriscaria reabrir o arquivo no meio de uma
/// consulta pendente.

@ProviderFor(appDatabase)
final appDatabaseProvider = AppDatabaseProvider._();

/// `keepAlive`: a conexão com o banco vive pelo tempo do app — recriar a
/// cada tela seria caro e arriscaria reabrir o arquivo no meio de uma
/// consulta pendente.

final class AppDatabaseProvider
    extends $FunctionalProvider<AppDatabase, AppDatabase, AppDatabase>
    with $Provider<AppDatabase> {
  /// `keepAlive`: a conexão com o banco vive pelo tempo do app — recriar a
  /// cada tela seria caro e arriscaria reabrir o arquivo no meio de uma
  /// consulta pendente.
  AppDatabaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appDatabaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appDatabaseHash();

  @$internal
  @override
  $ProviderElement<AppDatabase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AppDatabase create(Ref ref) {
    return appDatabase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppDatabase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppDatabase>(value),
    );
  }
}

String _$appDatabaseHash() => r'59cce38d45eeaba199eddd097d8e149d66f9f3e1';
