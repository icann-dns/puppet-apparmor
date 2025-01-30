# frozen_string_literal: true

require 'spec_helper'

describe 'apparmor' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:params) do
        {
          local_overrides: {
            'usr.sbin.array' => {
              'content_type' => 'array',
              'content' => ['/foo r', '/bar rw'],
            },
            'usr.sbin.source' => {
              'content_type' => 'source',
              'content' => 'puppet:///modules/apparmor/usr.sbin.source',
            },
            'usr.sbin.string' => {
              'content_type' => 'string',
              'content' => '/foo r,',
            },
       #      'usr.sbin.template' => {
       #        'content_type' => 'template',
       #        'content' => 'apparmor/usr.sbin.template',
       #      },
          },
        }
      end

      it { is_expected.to compile }
      it { is_expected.to contain_class('apparmor') }
      it { is_expected.to contain_package('apparmor') }
      it { is_expected.to contain_service('apparmor') }
      it do
        is_expected.to contain_file('/etc/apparmor.d/local/usr.sbin.array').
          with_content("/foo r,\n/bar rw,")
      end
      it do
        is_expected.to contain_file('/etc/apparmor.d/local/usr.sbin.source').
          with_source('puppet:///modules/apparmor/usr.sbin.source')
      end
      it do
        is_expected.to contain_file('/etc/apparmor.d/local/usr.sbin.string').
          with_content("/foo r,")
      end
      # it do
      #   allow(Puppet::Parser::Functions.function(:template)).to receive(:call).
      #     with('apparmor/usr.sbin.template').
      #     and_return('/bar rw,')
      #   is_expected.to contain_file('/etc/apparmor.d/local/usr.sbin.template').
      #     with_content("/bar rw,")
      # end
    end
  end
end