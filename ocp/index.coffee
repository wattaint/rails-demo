#!/usr/bin/env coffee
_       = require 'lodash'
program = require 'commander'
ejs     = require 'ejs'
fs      = require 'fs'
Promise = require 'bluebird'
fg      = require 'fast-glob'
fsx     = require 'fs-extra'
yaml    = require 'js-yaml'
path    = require 'path'
colors  = require 'colors'
{ promisify } = require 'util'

process.on 'unhandledRejection', (reason, p) ->
  console.log 'Unhandled Rejection at: Promise', p
  process.exit 1

SCRIPT_DIR      = path.dirname __filename
TEMPLATE_DIR    = path.join SCRIPT_DIR, 'templates'
OUTPUT_DIR      = path.join SCRIPT_DIR, 'outputs'
PROFILE_CONFIG  = path.join SCRIPT_DIR, 'profiles.yml'

writeFile = promisify fs.writeFile

railsTemplateFile = path.join TEMPLATE_DIR, '001_rails.yml'

loadProfile = (aProfileName) ->
  fileData = yaml.safeLoad fs.readFileSync PROFILE_CONFIG

  profiles = []
  for site, siteConfig of fileData
    for envTier, envConfig of siteConfig
      profiles.push "#{site}__#{envTier}"

  profiles.sort()
  profiles = _(profiles).reject (e) -> e.startsWith '_'
                        .value()

  unless _.isString aProfileName
    console.log yaml.dump profiles
    process.exit 2

  unless aProfileName in profiles
    console.log colors.red.bold "Profile not found! [#{aProfileName}]"
    console.log yaml.dump profiles
    process.exit 1

  siteName  = _.first aProfileName.split '__'
  envTier   = _.last aProfileName.split '__'

  config = _(fileData).get "#{siteName}.#{envTier}"
  if _.isObject(config) and !_.isArray(config)
    _.extend config, { siteName, envTier }

loadTemplates = ->
  fg.sync path.join TEMPLATE_DIR, '*.yml'

main = (profile) ->
  profileConfig = loadProfile profile

  fsx.ensureDirSync OUTPUT_DIR
  outputDir = path.join OUTPUT_DIR, profile

  fsx.removeSync path.join outputDir, "*"
  fsx.ensureDirSync outputDir

  templateFiles = loadTemplates()
  outFiles = await Promise.mapSeries templateFiles, (templateFile) ->
    str = await ejs.renderFile templateFile, profileConfig
    outFile = path.join outputDir, path.basename(templateFile)
    console.log '  -> ', colors.green '.' + _.last(outFile.split __dirname)
    writeFile outFile, str

if require.main == module
  aProfile = null
  program
    .arguments '<profile>'
    .action (profile) ->
      aProfile = profile
      main profile

    .parse process.argv
      
  unless _.isString aProfile
    make_red = (txt) -> colors.red txt
    program.outputHelp make_red
